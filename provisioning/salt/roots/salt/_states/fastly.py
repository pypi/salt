import requests


class DictDiffer(object):
    """
    Calculate the difference between two dictionaries as:
    (1) items added
    (2) items removed
    (3) keys same in both but changed values
    (4) keys same in both and unchanged values
    """
    def __init__(self, current_dict, past_dict):
        self.current_dict, self.past_dict = current_dict, past_dict
        self.current_keys, self.past_keys = [
            set(d.keys()) for d in (current_dict, past_dict)
        ]
        self.intersect = self.current_keys.intersection(self.past_keys)

    def added(self):
        return self.current_keys - self.intersect

    def removed(self):
        return self.past_keys - self.intersect

    def changed(self):
        return set(o for o in self.intersect
                   if self.past_dict[o] != self.current_dict[o])

    def unchanged(self):
        return set(o for o in self.intersect
                   if self.past_dict[o] == self.current_dict[o])


class FastlyError(Exception):
    pass


class Fastly(object):

    def __init__(self, api_key, domain="https://api.fastly.com"):
        self.api_key = api_key
        self.domain = domain

        self.session = requests.session()
        self.service_id = None
        self.version = None

    def _make_url(self, path):
        return self.domain + path % {
            "s_id": self.service_id,
            "v_num": self.version,
        }

    def _get(self, path, *args, **kwargs):
        resp = self.session.get(
            self._make_url(path),
            *args,
            headers={
                "Accept": "application/json",
                "Fastly-Key": self.api_key,
            },
            **kwargs
        )
        try:
            resp.raise_for_status()
        except requests.HTTPError:
            raise FastlyError(resp.json()["detail"])
        return resp.json()

    def _post(self, path, *args, **kwargs):
        resp = self.session.post(
            self._make_url(path),
            *args,
            headers={
                "Accept": "application/json",
                "Fastly-Key": self.api_key,
            },
            **kwargs
        )
        try:
            resp.raise_for_status()
        except requests.HTTPError:
            raise FastlyError(resp.json()["detail"])
        return resp.json()

    def _put(self, path, *args, **kwargs):
        resp = self.session.put(
            self._make_url(path),
            *args,
            headers={
                "Accept": "application/json",
                "Fastly-Key": self.api_key,
            },
            **kwargs
        )
        try:
            resp.raise_for_status()
        except requests.HTTPError:
            raise FastlyError(resp.json()["detail"])
        return resp.json()

    def _delete(self, path, *args, **kwargs):
        resp = self.session.delete(
            self._make_url(path),
            *args,
            headers={
                "Accept": "application/json",
                "Fastly-Key": self.api_key,
            },
            **kwargs
        )
        try:
            resp.raise_for_status()
        except requests.HTTPError:
            raise FastlyError(resp.json()["detail"])
        return resp.json()

    def get_service_by_id(self, id_):
        return self._get("/service/%s/details" % id_)

    def get_service_by_name(self, name):
        services = [x for x in self._get("/service") if x["name"] == name]

        if len(services) == 1:
            return self.get_service_by_id(services[0]["id"])
        elif len(services) > 1:
            raise RuntimeError("Too many services returned for '%s'" % name)

    def create_service(self, name):
        service_id = self._post("/service", data={"name": name})["id"]
        return self.get_service_by_id(service_id)

    def get_next_version(self, service):
        versions = sorted(
            [x for x in service["versions"] if not x["locked"]],
            key=lambda x: x["number"],
        )

        if versions:
            return versions[0]

        # We don't already have a version, so we'll clone the active version
        return self._put("/service/%s/version/%s/clone" % (
            service["id"],
            service["active_version"]["number"],
        ))

    def validate(self):
        return self._get("/service/%(s_id)s/version/%(v_num)s/validate")

    def activate(self):
        return self._put("/service/%(s_id)s/version/%(v_num)s/activate")

    def differs(self, other_version):
        if other_version is None:
            return True

        data = self._get(
            "/service/%%(s_id)s/diff/from/%%(v_num)s/to/%s" % (
                other_version["number"]
            )
        )
        for line in data["diff"].splitlines():
            if line and not line.startswith(" "):
                return True
        else:
            return False

    def sync_domains(self, domains):
        if domains is None:
            domains = []

        # Get a list of all domains on the service
        current_domains = [
            x["name"]
            for x in self._get("/service/%(s_id)s/version/%(v_num)s/domain")
        ]

        # Figure out what changes need to be made
        deleted = set(current_domains) - set(domains)
        created = set(domains) - set(current_domains)

        # Delete any domains we no longer need
        for domain in deleted:
            self._delete(
                "/service/%%(s_id)s/version/%%(v_num)s/domain/%s" % domain
            )

        # Create any domains we need now
        for domain in created:
            self._post(
                "/service/%(s_id)s/version/%(v_num)s/domain",
                data={"name": domain},
            )

        # Figure out our changes
        return _format_changes(
            {"created": sorted(created), "deleted": sorted(deleted)},
            keys=["created", "deleted"],
        )

    def sync_backends(self, backends):
        if backends is None:
            backends = []

        # Get a list of all the backends on the service
        current_backends = self._get(
            "/service/%(s_id)s/version/%(v_num)s/backend"
        )

        # Figure out what changes need to be made
        deleted = (set(x["name"] for x in current_backends) -
                   set(x["name"] for x in backends))
        created = (set(x["name"] for x in backends) -
                   set(x["name"] for x in current_backends))
        modified = set()

        # Delete any backends we no longer need
        for backend in deleted:
            self._delete(
                "/service/%%(s_id)s/version/%%(v_num)s/backend/%s" % backend
            )

        # Create any backends we need now
        for backend in (x for x in backends if x["name"] in created):
            self._post(
                "/service/%(s_id)s/version/%(v_num)s/backend",
                data=backend,
            )

        # Modify any remaining backends
        for backend in (x for x in backends if x["name"] not in created):
            current = self._get(
                "/service/%%(s_id)s/version/%%(v_num)s/backend/%s" % (
                    backend["name"],
                ),
            )

            diff = DictDiffer(backend, current)
            if diff.changed():
                modified.add(backend["name"])
                self._put(
                    "/service/%%(s_id)s/version/%%(v_num)s/backend/%s" % (
                        backend["name"],
                    ),
                    data=dict(
                        (k, v)
                        for k, v in backend.items()
                        if k in diff.changed()
                    )
                )

        # Figure out our changes
        return _format_changes(
            {
                "created": sorted(created),
                "deleted": sorted(deleted),
                "modified": sorted(modified),
            },
            keys=["created", "deleted", "modified"],
        )


def service(name, id=None, domains=None, backends=None):
    fastly = Fastly(__salt__['config.option']("fastly.api_key"))

    changes = {
        "name": name,
        "changes": {},
    }

    # Get the service, either by ID if we were given it, or by name otherwise
    if id is not None:
        service = fastly.get_service_by_id(id)
    else:
        service = fastly.get_service_by_name(name)

    # If we didn't get a service then we should create one
    if service is None:
        service = fastly.create_service(name)
        changes["changes"]["service"] = "created %s [%s]" % (
            name,
            service["id"],
        )

    # Determine which version we should be operating on
    version = fastly.get_next_version(service)

    # Set our Service ID and version number
    fastly.service_id = service["id"]
    fastly.version = version["number"]

    # Update the domains on the service
    changes["changes"]["domains"] = fastly.sync_domains(domains)

    # Update the backends on the service
    changes["changes"]["backends"] = fastly.sync_backends(backends)

    # Filter out the empty changes
    changes["changes"] = dict(
        (k, v) for k, v in changes["changes"].items() if v
    )

    # Check to see if our version differs from the active version, or if there
    # is no active version
    if not fastly.differs(service["active_version"]):
        changes["result"] = True
        changes["comment"] = "Fastly service '%s' already up to date" % name
    else:
        # Validate our changes
        validation = fastly.validate()
        if validation["status"] == "error":
            changes["result"] = False
            changes["comment"] = validation["msg"]
        else:
            # Activate our changes
            fastly.activate()

            changes["result"] = True
            changes["comment"] = "Fastly service '%s' updated" % name

    return changes


def _format_changes(changes, keys=None):
    if keys is None:
        keys = changes.keys()

    out = []

    if len(changes) > 1:
        maxlen = max(len(k) for k in changes.keys())
        for key in keys:
            if changes[key]:
                out.extend([
                    "\n",
                    " " * 24,
                    key,
                    ": ",
                    (" " * (maxlen - len(key))),
                    " ".join(sorted(changes[key]))
                ])
    elif len(changes) == 1:
        out = [keys[0], ": ", changes[keys[0]]]

    return "".join(out)
