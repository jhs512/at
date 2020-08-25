# 할일 리스트

## 할일 리스트

- [o] 회원가입
- [o] 로그인
- [ ] 로그아웃

# my.cnf mysqld 설정

```
[mysqld]
innodb_log_file_size = 200M # file 테이블에 실제 파일을 저장하려면
max_allowed_packet = 200M # file 테이블에 실제 파일을 저장하려면
group_concat_max_len = 1000000 # group_concat을 화려하게 사용하려면
lower_case_table_names = 2 # 테이블 명에 소문자 허용
```

# application.yml

```
server:
  error:
    include-exception: true # 이걸 안하면, 실 서비스 환경에서 오류가안나옴
    include-stacktrace: always # 이걸 안하면, 실 서비스 환경에서 오류가안나옴
    include-message: always # 이걸 안하면, 실 서비스 환경에서 오류가안나옴
    include-binding-errors: always # 이걸 안하면, 실 서비스 환경에서 오류가안나옴
spring:
  servlet:
    multipart:
      location: /tmp # 서버에 배포할 때는 이렇게 되어야 합니다.
```

# 메이븐 원격 배포 방법

- JAVA_HOME 환경변수가 이미 존재해야 합니다.
- 윈도우 키 + CMD
- cd C:\work\sts-4.4.0.RELEASE-workspace\at
- mvnw.cmd tomcat7:redeploy

# 운영환경에서 만들어야 실행해야하는 초기 DB 세팅

# DB 사용자 생성

- GRANT ALL PRIVILEGES ON `at`.\* TO `at`@`localhost` IDENTIFIED BY 'sbs123414';

# 서버쪽 세팅

- 웹앱이나 톰캣 리스타트시 세션 유지
  - /opt/tomcat/apache-tomcat-9.0.36/conf/context.xml
    - <Manager pathname=""><saveOnRestart>false</saveOnRestart></Manager>
      - 추가
