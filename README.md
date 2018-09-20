# Bohu

``Bohu`` is intended to easyfy filesystem and administrative tasks,
it provides an application programming interface (API)
to an abstract operating system making
it easier and quicker to develop code for multiple software or platforms.

## Shell

``Bohu`` provides ``sh``, ``capture`` and ``capture!`` low-level methods.
And, configuration permits new methods declaration, using dialects.

```yaml
# config.yml
commands:
  adduser:
    actions:
      create_user:
        assign_password: false
        login_shell:
          - '%<login_shell>s'
          - '/bin/bash'
          login: '%<login>s'
```

```yaml
# dialects/default/adduser.yml
system: ['-S', true]
login_shell: ['-s', '%<login_shell>s']
assign_password: ['-D', false]
```

Commands are built from ``commands`` configuration, and uses a dialect.
Dialect is responsible to transform known options into command line options.
Config permits to choose used dialect by a command:

```yaml
commands:
   adduser:
     dialect: default
     executable: adduser
 ```

Dialects paths can be added by configuration:

```yaml
dialects:
  paths:
    - dialects
```
