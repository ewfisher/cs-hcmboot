namespace: Integrations.demo.aos.tools
flow:
  name: delete_file
  inputs:
    - host: 10.0.46.86
    - username: root
    - password: admin@123
    - filename: install_tomcat.sh
  workflow:
    - delete_file:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${'cd '+get_sp('script_location')+' && rm -f '+filename}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      delete_file:
        x: 166
        y: 212
        navigate:
          c621c271-3bbb-7745-0bd1-f8e180b658c0:
            targetId: fcc2b503-1da4-3750-ba38-a1223e867544
            port: SUCCESS
    results:
      SUCCESS:
        fcc2b503-1da4-3750-ba38-a1223e867544:
          x: 527
          y: 230
