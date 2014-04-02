
requests:
  pip.installed:
    - reload_modules: true

Warehouse2:
  fastly.service:
    - domains:
      - pypi-preview2.a.ssl.fastly.net
      - warehouse2.python.org
    - backends:
      - name: warehouse0.pypi.io
        address: 162.242.239.29
        port: 9001
        shield: ashburn-va-us
        use_ssl: true
        ssl_hostname: warehouse0.pypi.io
        ssl_ca_cert: |
          -----BEGIN CERTIFICATE-----
          MIIDjjCCAnagAwIBAwIQYyQrLJSJJt4SV1S4iQr+XTANBgkqhkiG9w0BAQUFADCB
          gjELMAkGA1UEBhMCVVMxDTALBgNVBAgTBFV0YWgxFzAVBgNVBAcTDlNhbHQgTGFr
          ZSBDaXR5MRIwEAYDVQQKEwlTYWx0U3RhY2sxGzAZBgNVBAMTEndhcmVob3VzZTAu
          cHlwaS5pbzEaMBgGCSqGSIb3DQEJARYLeHl6QHBkcS5uZXQwHhcNMTQwMzAyMjAw
          NDMxWhcNMTUwMzAyMjAwNDMxWjCBgjELMAkGA1UEBhMCVVMxDTALBgNVBAgTBFV0
          YWgxFzAVBgNVBAcTDlNhbHQgTGFrZSBDaXR5MRIwEAYDVQQKEwlTYWx0U3RhY2sx
          GzAZBgNVBAMTEndhcmVob3VzZTAucHlwaS5pbzEaMBgGCSqGSIb3DQEJARYLeHl6
          QHBkcS5uZXQwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC2gpvRqCB7
          LprFM/U0UB/AJZ9AMYzeR1GoFECpTgYI1EMOXzsUn72DZDgXrjGl2kueJkKdfWOw
          evBrd+EjxVd9rpqrSgGEmpOOkAK+jJTmMNdW01uveyrq6wT1m5+aJfmf0KmK2dSg
          56XUppIEuZgEXSIboR6WERn8PcK6UTsmeNaLyamV4ZqvqiNaraVN8wGXInnTnBxA
          0rPX9oMFNu/C2ccCYl6p16aXX0wUytb8ByZK/eynOeTRfjFGPuy3blz6PAOTUWDv
          ffueTDg9MTWCtLc9gTYi7urnARFk/wRIvLmoIFb5YHFyTNEy+W5vHRquIQvNsJbo
          7IzfB//o8TttAgMBAAEwDQYJKoZIhvcNAQEFBQADggEBAGJo2EKKRoDjMayJylft
          hHNB3RhWe9bKjG9Nw/HperCacfbpvVWQ9dM76l8K279iF3JRpBjbOhTNvnEtu4h2
          guEcwo+FV5riAk51JWohZegznibJsdCre0+RW9bBSz+fRewr0iF06jtoqrMl5kl+
          G4x0SbSZKKIYAcTEZl6fkPwFA6L5OviYKoZx2qtFwSE6XlS8b3fJ/o3UxM5HEaKv
          /3IqjViEFOXkq7C8WlOSwe0lH01m6CLW0xaIFCC9cV0TIToGj2WBJrPM0QJ43CbN
          SETbc6ejQuQzsL2wYVNgbjt3Q/TOrYROqum1UL9FNoatQ5kR/heFdnplo6Vge1Z8
          BK8=
          -----END CERTIFICATE-----

