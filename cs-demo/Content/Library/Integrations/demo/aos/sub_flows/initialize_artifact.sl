namespace: Integrations.demo.aos.sub_flows
flow:
  name: initialize_artifact
  inputs:
    - host: 10.0.46.86
    - username: root
    - password: admin@123
    - artifact_url:
        default: 'http://vmdocker.hcm.demo.local:36980/job/AOS/lastSuccessfulBuild/artifact/shipex/target/ShipEx.war'
        required: false
    - script_url:
        required: false
    - parameters:
        required: false
  workflow:
    - is_artifact_given:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${artifact_url}'
        navigate:
          - SUCCESS: copy_script
          - FAILURE: copy_artifact
    - copy_artifact:
        do:
          Integrations.demo.aos.sub_flows.remote_copy: []
        publish:
          - artifact_name: '${filename}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: copy_script
    - copy_script:
        do:
          Integrations.demo.aos.sub_flows.remote_copy: []
        publish:
          - script_name: '${filename}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: execute_script
    - execute_script:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${'cd '+get_sp('script_location')+' && chmod 755 '+script_name+' && sh '+script_name+' '+get('artifact_name', '')+' '+get('parameters', '')+' > '+script_name+'.log'}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        publish:
          - command_return_code
        navigate:
          - SUCCESS: delete_script
          - FAILURE: delete_script
    - delete_script:
        do:
          Integrations.demo.aos.tools.delete_file: []
        navigate:
          - SUCCESS: is_true
          - FAILURE: on_failure
    - is_true:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "str(command_return_code =='0')"
        navigate:
          - 'TRUE': SUCCESS
          - 'FALSE': FAILURE
  outputs:
    - command_return_code
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      is_true:
        x: 643
        y: 433
        navigate:
          a409db32-45da-52b5-d025-48a2a3ca9749:
            targetId: 62026c16-de41-58a3-a0c9-e3c435e468c9
            port: 'TRUE'
          8f2611d1-72f4-afa7-be58-0bf7fca61023:
            targetId: fae16fea-6bab-faf4-601b-c5cd618e44bc
            port: 'FALSE'
      copy_artifact:
        x: 211
        y: 289
      copy_script:
        x: 461
        y: 288
      execute_script:
        x: 287
        y: 443
      delete_script:
        x: 460
        y: 450
      is_artifact_given:
        x: 416
        y: 123
    results:
      SUCCESS:
        62026c16-de41-58a3-a0c9-e3c435e468c9:
          x: 717
          y: 357
      FAILURE:
        fae16fea-6bab-faf4-601b-c5cd618e44bc:
          x: 699
          y: 549
