import salt.utils
import salt.modules.cmdmod

__salt__ = {
    'cmd.run_all': salt.modules.cmdmod._run_all_quiet,
}

KEYS = {
    'provider_hostname': 'vm-data/hostname',
    'provider': 'vm-data/provider_data/provider',
    'region': 'vm-data/provider_data/region',
}

def xenstore():
    data = dict()
    cmd = salt.utils.which('xenstore-read')
    if not cmd:
        return data
    try:
        command = '{0} domid'.format(cmd)
        ret = __salt__['cmd.run_all'](command)
        domid = ret['stdout'].rstrip()
    except Exception as e:
        return data

    found = {}
    for key, xkey in KEYS.iteritems():
        try:
            command = '{0} /local/domain/{1}/{2}'.format(cmd, domid, xkey)
            ret = __salt__['cmd.run_all'](command)
            if ret and ret['retcode'] == 0:
                found[key] = ret['stdout']
        except Exception:
            pass
    data['datadog_tags_from_metadata'] = ['%s:%s' % (k, v) for k, v in found.items()]
    return data
