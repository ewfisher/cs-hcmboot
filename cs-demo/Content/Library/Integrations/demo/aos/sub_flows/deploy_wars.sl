namespace: Integrations.demo.aos.sub_flows
flow:
  name: deploy_wars
  inputs:
    - tomcat_host: 10.0.46.86
    - account_service_host: 10.0.46.86
    - db_host: 10.0.46.46
    - username: "${get_sp('vm_username')}"
    - password: "${get_sp('vm_password')}"
    - url: "${get_sp('war_repo_root_url')}"
  workflow:
    - deploy_account_service:
        do:
          Integrations.demo.aos.sub_flows.initialize_artifact:
            - host: '${account_service_host}'
            - username: '${username}'
            - password: '${password}'
            - artifact_url: "${url+'accountservice/target/accountservice.war'}"
            - script_url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/deploy_war.sh'
            - parameters: "${db_host+'postgres admin '+tomcat_host+' '+account_service_host}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: deploy_tm_wars
    - deploy_tm_wars:
        loop:
          for: "war in 'catalog','MasterCredit','order','ROOT','ShipEx','SafePay'"
          do:
            Integrations.demo.aos.sub_flows.initialize_artifact:
              - host: '${tomcat_host}'
              - username: '${username}'
              - password: '${password}'
              - artifact_url: "${url+war.lower()+'/target/'+war+'.war'}"
              - parameters: "${db_host+' postgres admin '+tomcat_host+' '+account_service_host}"
          break:
            - FAILURE
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      deploy_account_service:
        x: 371
        y: 222
      deploy_tm_wars:
        x: 526
        y: 217
        navigate:
          d231af6e-c6f3-eb27-f28a-803e6284a1d1:
            targetId: 42ade3f0-4e4b-644a-e277-209b49d3c6d1
            port: SUCCESS
    results:
      SUCCESS:
        42ade3f0-4e4b-644a-e277-209b49d3c6d1:
          x: 463
          y: 373
