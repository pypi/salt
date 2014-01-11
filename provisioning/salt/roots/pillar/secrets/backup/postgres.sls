
backup:
  directories:
    postgres-archives:
      source_directory: /var/lib/pgsql/9.3/backups/archives
      target_host: 172.16.57.201
      target_directory: /backup/postgres/archives
      target_user: postgres
      frequency: hourly
      user: postgres
      ssh_key: |
        -----BEGIN RSA PRIVATE KEY-----
        MIIEowIBAAKCAQEAsagAYbuOiROc0+vLjcKQXZqiP3mH3qXwPT1PAMWxkferuaz3
        fMciidmc01II6wili4puI7rRYALXwsJH45vxax0FjSWYWbUNYE/Gv26SIx3XYzhZ
        RC42tbxSpELFOnbJmBk2ccAcnjEJdfk1hOcZhq5qrIDZyvk8ItNUwlJmLN+jPDkB
        l5XuuuFwGqX3PuHAFOApX95h+8RSASZwktdr+REtSeKZp3wVTE/OZRiTA1v7wyOW
        MdgPOWyjgsJXtV6RrMSy3774O32jYggY6Y//6UhACOdrUqtIS7WEkuViQc9bXyUD
        xAgl1cWuixyiQekQ093mMjEEroBUgqx8UPI/xQIDAQABAoIBACigXa374SWRuZxw
        4LTDWJY/RXk0hpCw69ZlTcrEas4RkFC+sD31n/1cKVPd/7IX4RufBX7gOv80xzh/
        i0cOo0+2bE2R2lwxXiS3OaEPXRXwvg+vlCJWWyaGMXPk3Qt4nLNOmLe8kg7O8fXr
        joSdAKZe/oACW0viYREpuMlTZJBAFpqCq95j1t2dCA0moPQVjxhR4QAhLkT4siHv
        Ed3qgYT4Vj9nTiXW6cGbz9O8WjTg9ttW0llWBpRLsChLfx8fa0yiCv5qMNGOnH0D
        POf+0rAHq6ijuqqOBDeKqH/887/Tqx3mEEYjQhynIGhSOlFCp43MGegfMmwfvTVm
        LzvaHoUCgYEA2YUDnUFIEjHyGFMs4AriyJaByFAb1K5jJJkcp31IJ7pmLj6WQz2O
        usBosNuuK9c4Xm00848ukSOXdOLMXViyG0XK2eXbObAUt19RD5+soC7F/mTiYPPA
        EOUqqgZ+VcxqII6tLIxKeS4HQpz0Zc2zncl8BPAR3eOqg9IG+GSJRR8CgYEA0RWq
        Fgjcm2Dhcb1q4Ie812Htr+0zeILym3OZUxGOY1MvbNknlf0Q33uQLiou8YLkmwZF
        CehDPolmwn/ahVxFhbkzSCbPjM7BNxtvwbaZaqVoNmVS9gE7fHOPhCgKijdU0L7s
        IN6eJ6SzApkqf0BQ1Yqrik9OixbYUguvHxLn2psCgYBzyooFAUZjYTEV39kInuLg
        krYdsv9NtVNTnSoSwu9RLrnMLkcBHljHczuHwjmyXsxD//BrIzJP0tmCQGU338pY
        GEwGuIR97gzpHJVjMsXLM3r0lDGqGLeKhuOyROiltb5c/HaVO009utHklPbI5rqR
        6Trayg1IyDPyHjDVs3cbUwKBgQCQnUxsOyri6WplMh9HN3tc+aXdxdGQ6/mDnbwR
        4ZW7i2DFB5nCuyu9d4hs9c5MSz11ICwGQzine3+wzZ/GF+EaMdOPdxCdErA/PmHY
        +UQ5qDhhT0nHT2jmlkNQpCVOHiEy1KsbvP5k6xzJkkj7hO+kE2q8mkf4Gg/7B4vT
        kU7+OwKBgEfjMJIvGt2xhS3tZZgYKVlh3/gymzD0eoa4DPwVmjWnQgLVtRmV25X2
        5FWJLq+ryEbJNI6Rl3LG3c/K15I8jNQpuVRgeK7ydf2U3g4pzFPOlsb5UgJEETdi
        pqMI3F6ButHsMcwjZotivkf3baM1FmnjIJ4oeTFPyagaLZdRCuiT
        -----END RSA PRIVATE KEY-----
    postgres-base:
      source_directory: /var/lib/pgsql/9.3/backups/base
      target_host: 172.16.57.201
      target_directory: /backup/postgres/base
      target_user: postgres
      frequency: daily
      user: postgres
      pre_script: 'pg_basebackup -D /var/lib/pgsql/9.3/backups/base/$(date --iso-8601=seconds)'
      post_script: '/usr/local/backup/postgres-archives/scripts/backup.bash'
      cleanup_script: 'find /var/lib/pgsql/9.3/backups/base -maxdepth 1 -type d -mmin +10 -execdir rm -rf {} \;'
      ssh_key: |
        -----BEGIN RSA PRIVATE KEY-----
        MIIEowIBAAKCAQEAsagAYbuOiROc0+vLjcKQXZqiP3mH3qXwPT1PAMWxkferuaz3
        fMciidmc01II6wili4puI7rRYALXwsJH45vxax0FjSWYWbUNYE/Gv26SIx3XYzhZ
        RC42tbxSpELFOnbJmBk2ccAcnjEJdfk1hOcZhq5qrIDZyvk8ItNUwlJmLN+jPDkB
        l5XuuuFwGqX3PuHAFOApX95h+8RSASZwktdr+REtSeKZp3wVTE/OZRiTA1v7wyOW
        MdgPOWyjgsJXtV6RrMSy3774O32jYggY6Y//6UhACOdrUqtIS7WEkuViQc9bXyUD
        xAgl1cWuixyiQekQ093mMjEEroBUgqx8UPI/xQIDAQABAoIBACigXa374SWRuZxw
        4LTDWJY/RXk0hpCw69ZlTcrEas4RkFC+sD31n/1cKVPd/7IX4RufBX7gOv80xzh/
        i0cOo0+2bE2R2lwxXiS3OaEPXRXwvg+vlCJWWyaGMXPk3Qt4nLNOmLe8kg7O8fXr
        joSdAKZe/oACW0viYREpuMlTZJBAFpqCq95j1t2dCA0moPQVjxhR4QAhLkT4siHv
        Ed3qgYT4Vj9nTiXW6cGbz9O8WjTg9ttW0llWBpRLsChLfx8fa0yiCv5qMNGOnH0D
        POf+0rAHq6ijuqqOBDeKqH/887/Tqx3mEEYjQhynIGhSOlFCp43MGegfMmwfvTVm
        LzvaHoUCgYEA2YUDnUFIEjHyGFMs4AriyJaByFAb1K5jJJkcp31IJ7pmLj6WQz2O
        usBosNuuK9c4Xm00848ukSOXdOLMXViyG0XK2eXbObAUt19RD5+soC7F/mTiYPPA
        EOUqqgZ+VcxqII6tLIxKeS4HQpz0Zc2zncl8BPAR3eOqg9IG+GSJRR8CgYEA0RWq
        Fgjcm2Dhcb1q4Ie812Htr+0zeILym3OZUxGOY1MvbNknlf0Q33uQLiou8YLkmwZF
        CehDPolmwn/ahVxFhbkzSCbPjM7BNxtvwbaZaqVoNmVS9gE7fHOPhCgKijdU0L7s
        IN6eJ6SzApkqf0BQ1Yqrik9OixbYUguvHxLn2psCgYBzyooFAUZjYTEV39kInuLg
        krYdsv9NtVNTnSoSwu9RLrnMLkcBHljHczuHwjmyXsxD//BrIzJP0tmCQGU338pY
        GEwGuIR97gzpHJVjMsXLM3r0lDGqGLeKhuOyROiltb5c/HaVO009utHklPbI5rqR
        6Trayg1IyDPyHjDVs3cbUwKBgQCQnUxsOyri6WplMh9HN3tc+aXdxdGQ6/mDnbwR
        4ZW7i2DFB5nCuyu9d4hs9c5MSz11ICwGQzine3+wzZ/GF+EaMdOPdxCdErA/PmHY
        +UQ5qDhhT0nHT2jmlkNQpCVOHiEy1KsbvP5k6xzJkkj7hO+kE2q8mkf4Gg/7B4vT
        kU7+OwKBgEfjMJIvGt2xhS3tZZgYKVlh3/gymzD0eoa4DPwVmjWnQgLVtRmV25X2
        5FWJLq+ryEbJNI6Rl3LG3c/K15I8jNQpuVRgeK7ydf2U3g4pzFPOlsb5UgJEETdi
        pqMI3F6ButHsMcwjZotivkf3baM1FmnjIJ4oeTFPyagaLZdRCuiT
        -----END RSA PRIVATE KEY-----
