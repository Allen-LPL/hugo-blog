image: tico/docker

before_script:
  - docker info
  
stages:
  - deploy
  - release
  - merge-xiedi
  - merge-allen
  - merge-zwq
    
web001-deploy:
  stage: deploy
  script:
    - cd /var/www/ttz-web/ttz-web
    - git config user.name "dazuiba-web"
    - git config user.email "dazuiba-web"
    - git status
    - git pull
  only:
    - master-bak
  tags:
    - docker-runner-web001

web002-deploy:
  stage: deploy
  script:
    - cd /var/www/ttz-web/ttz-web
    - git config user.name "dazuiba-web"
    - git config user.email "dazuiba-web"
    - git status
    - git pull
  only:
    - master-bak
  tags:
    - docker-runner-web002
    
adminweb-deploy:
  stage: deploy
  script:
    - cd /var/www/ttz-web/ttz-web
    - git config user.name "dazuiba-web"
    - git config user.email "dazuiba-web"
    - git status
    - git pull
  only:
    - master-bak
  tags:
    - docker-runner-admin-web
    
web001-merge-xiedi:
  stage: merge-xiedi
  script:
    - cd /var/www/ttz-web/ttz-web
    - git config user.name "dazuiba-web-xiedi"
    - git config user.email "dazuiba-web-xiedi"
    - git checkout master
    - git status
    #- git remote update
    - git fetch
    - git branch -a
    - git pull
    - git checkout xiedi
    - git rebase master
    - git pull
    - git checkout master
    - git merge xiedi -m 'auto merge'
    - git status
    - git pull
    - git status
    - git push
  only:
    - xiedi
  tags:
    - docker-runner-web001
    
web002-merge-xiedi:
  stage: merge-xiedi
  script:
    - cd /var/www/ttz-web/ttz-web
    - git config user.name "dazuiba-web-xiedi"
    - git config user.email "dazuiba-web-xiedi"
    - git checkout master
    - git status
    #- git remote update
    - git fetch
    - git branch -a
    - git pull
    - git checkout xiedi
    - git rebase master
    - git pull
    - git checkout master
    - git merge xiedi -m 'auto merge'
    - git status
    - git pull
    - git status
  only:
    - xiedi
  tags:
    - docker-runner-web002
    
adminweb-merge-xiedi:
  stage: merge-xiedi
  script:
    - cd /var/www/ttz-web/ttz-web
    - git config user.name "dazuiba-web-xiedi"
    - git config user.email "dazuiba-web-xiedi"
    - git checkout master
    - git status
    #- git remote update
    - git fetch
    - git branch -a
    - git pull
    - git checkout xiedi
    - git rebase master
    - git pull
    - git checkout master
    - git merge xiedi -m 'auto merge'
    - git status
    - git pull
    - git status
    - git push
  only:
    - xiedi
  tags:
    - docker-runner-admin-web
    
web001-merge-allen:
  stage: merge-allen
  script:
    - cd /var/www/ttz-web/ttz-web
    - git config user.name "dazuiba-web-allen"
    - git config user.email "dazuiba-web-allen"
    - git checkout master
    - git status
    #- git remote update
    - git fetch
    - git branch -a
    - git pull
    - git checkout allen
    - git rebase master
    - git pull
    - git checkout master
    - git merge allen -m 'auto merge'
    - git status
    - git pull
    - git status
    - git push
  only:
    - allen
  tags:
    - docker-runner-web001
    
web002-merge-allen:
  stage: merge-allen
  script:
    - cd /var/www/ttz-web/ttz-web
    - git config user.name "dazuiba-web-allen"
    - git config user.email "dazuiba-web-allen"
    - git checkout master
    - git status
    #- git remote update
    - git fetch
    - git branch -a
    - git pull
    - git checkout allen
    - git rebase master
    - git pull
    - git checkout master
    - git merge allen -m 'auto merge'
    - git status
    - git pull
    - git status
  only:
    - allen
  tags:
    - docker-runner-web002
        
adminweb-merge-allen:
  stage: merge-allen
  script:
    - cd /var/www/ttz-web/ttz-web
    - git config user.name "dazuiba-web-allen"
    - git config user.email "dazuiba-web-allen"
    - git checkout master
    - git status
    #- git remote update
    - git fetch
    - git branch -a
    - git pull
    - git checkout allen
    - git rebase master
    - git pull
    - git checkout master
    - git merge allen -m 'auto merge'
    - git status
    - git pull
    - git status
  only:
    - allen
  tags:
    - docker-runner-admin-web
    
web001-merge-zwq:
  stage: merge-zwq
  script:
    - cd /var/www/ttz-web/ttz-web
    - git config user.name "dazuiba-web-zwq"
    - git config user.email "dazuiba-web-zwq"
    - git checkout master
    - git status
    #- git remote update
    - git fetch
    - git branch -a
    - git pull
    - git checkout zwq
    - git rebase master
    - git pull
    - git checkout master
    - git merge zwq -m 'auto merge'
    - git status
    - git pull
    - git status
    - git push
  only:
    - zwq
  tags:
    - docker-runner-web001
    
web002-merge-zwq:
  stage: merge-zwq
  script:
    - cd /var/www/ttz-web/ttz-web
    - git config user.name "dazuiba-web-zwq"
    - git config user.email "dazuiba-web-zwq"
    - git checkout master
    - git status
    #- git remote update
    - git fetch
    - git branch -a
    - git pull
    - git checkout zwq
    - git rebase master
    - git pull
    - git checkout master
    - git merge zwq -m 'auto merge'
    - git status
    - git pull
    - git status
  only:
    - zwq
  tags:
    - docker-runner-web002
    
adminweb-merge-zwq:
  stage: merge-zwq
  script:
    - cd /var/www/ttz-web/ttz-web
    - git config user.name "dazuiba-web-zwq"
    - git config user.email "dazuiba-web-zwq"
    - git checkout master
    - git status
    #- git remote update
    - git fetch
    - git branch -a
    - git pull
    - git checkout zwq
    - git rebase master
    - git pull
    - git checkout master
    - git merge zwq -m 'auto merge'
    - git status
    - git pull
    - git status
  only:
    - zwq
  tags:
    - docker-runner-admin-web
