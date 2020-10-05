# DB 세팅
DROP DATABASE IF EXISTS `at`;
CREATE DATABASE `at`;
USE `at`;

# article 테이블 세팅
CREATE TABLE article (
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME,
    updateDate DATETIME,
    delDate DATETIME,
	delStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
	displayStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
    title CHAR(200) NOT NULL,
    `body` LONGTEXT NOT NULL
);

# article 테이블에 테스트 데이터 삽입
INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
title = '제목1',
`body` = '내용1';

INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
title = '제목2',
`body` = '내용2',
displayStatus = 1;

INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
title = '제목3',
`body` = '내용3',
displayStatus = 1;

# member 테이블 세팅
CREATE TABLE `member` (
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME,
    updateDate DATETIME,
    delDate DATETIME,
	delStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
	authStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
    loginId CHAR(20) NOT NULL UNIQUE,
    loginPw CHAR(100) NOT NULL,
    `name` CHAR(20) NOT NULL,
    `nickname` CHAR(20) NOT NULL,
    `email` CHAR(100) NOT NULL,
    `phoneNo` CHAR(20) NOT NULL
);

# member 테이블에 테스트 데이터 삽입
INSERT INTO `member`
SET regDate = NOW(),
updateDate = NOW(),
loginId = 'admin',
loginPw = SHA2('admin', 256),
`name` = '관리자',
`nickname` = '관리자',
`email` = '',
`phoneNo` = '';


# article 테이블 세팅
CREATE TABLE articleReply (
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME,
    updateDate DATETIME,
    memberId INT(10) UNSIGNED NOT NULL,
    articleId INT(10) UNSIGNED NOT NULL,
    delDate DATETIME,
	delStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
	displayStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
    `body` LONGTEXT NOT NULL
);

# articleReply 테이블에 테스트 데이터 삽입
INSERT INTO articleReply
SET regDate = NOW(),
updateDate = NOW(),
memberId = 1,
articleId = 1,
displayStatus = 1,
`body` = '내용1';

/* 게시물 댓글을 범용 댓글 테이블로 변경 */
RENAME TABLE `articleReply` TO `reply`;

ALTER TABLE `reply` ADD COLUMN `relTypeCode` CHAR(50) NOT NULL AFTER `memberId`,
CHANGE `articleId` `relId` INT(10) UNSIGNED NOT NULL;
ALTER TABLE `at`.`reply` ADD INDEX (`relId`, `relTypeCode`);
UPDATE reply
SET relTypeCode = 'article'
WHERE relTypeCode = '';

/* 파일 테이블 생성 */
CREATE TABLE `file` (
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME,
    updateDate DATETIME,
    delDate DATETIME,
	delStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
	relTypeCode CHAR(50) NOT NULL,
	relId INT(10) UNSIGNED NOT NULL,
    originFileName VARCHAR(100) NOT NULL,
    fileExt CHAR(10) NOT NULL,
    typeCode CHAR(20) NOT NULL,
    type2Code CHAR(20) NOT NULL,
    fileSize INT(10) UNSIGNED NOT NULL,
    fileExtTypeCode CHAR(10) NOT NULL,
    fileExtType2Code CHAR(10) NOT NULL,
    fileNo TINYINT(2) UNSIGNED NOT NULL,
    `body` LONGBLOB
);

# 멤버 테이블 칼럼명 변경
ALTER TABLE `member` CHANGE `phoneNo` `cellphoneNo` CHAR(20) NOT NULL; 

# 게시물 테이블에 작성자 정보 추가
ALTER TABLE `article` ADD COLUMN `memberId` INT(10) UNSIGNED NOT NULL AFTER `delStatus`; 

UPDATE article
SET memberId = 1
WHERE memberId = 0;

# 파일 테이블에 유니크 인덱스 추가
ALTER TABLE `file` ADD UNIQUE INDEX (`relId`, `relTypeCode`, `typeCode`, `type2Code`, `fileNo`); 

# 파일 테이블의 기존 인덱스에 유니크가 걸려 있어서 relId가 0 인 동안 충돌이 발생할 수 있다. 그래서 일반 인덱스로 바꾼다.
ALTER TABLE `file` DROP INDEX `relId`, ADD INDEX (`relId` , `relTypeCode` , `typeCode` , `type2Code` , `fileNo`); 

# 게시물 테이블에 게시판 정보 추가
ALTER TABLE `article` ADD COLUMN `boardId` INT(10) UNSIGNED NOT NULL AFTER `delStatus`; 

UPDATE article
SET boardId = 1
WHERE boardId = 0;

# 게시판 테이블 추가
CREATE TABLE `board` (
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME,
    updateDate DATETIME,
    delDate DATETIME,
	delStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
    `code` CHAR(20) NOT NULL UNIQUE,
	`name` CHAR(20) NOT NULL UNIQUE
);

INSERT INTO `board`
SET regDate = NOW(),
updateDAte = NOW(),
`code` = 'free',
`name` = '자유';

# 직업 테이블 추가
CREATE TABLE `job` (
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME,
    updateDate DATETIME,
    delDate DATETIME,
	delStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
    `code` CHAR(20) NOT NULL UNIQUE,
	`name` CHAR(20) NOT NULL UNIQUE
);

INSERT INTO `job`
SET regDate = NOW(),
updateDAte = NOW(),
`code` = 'actor',
`name` = '배우';

# recruitment 테이블 세팅
CREATE TABLE recruitment (
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME,
    updateDate DATETIME,
    memberId INT(10) UNSIGNED NOT NULL,
    jobId INT(10) UNSIGNED NOT NULL,
    delDate DATETIME,
	delStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
	displayStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
    `title` CHAR(100) NOT NULL,
    `body` TEXT NOT NULL,
    addi TEXT
);

# applyment 테이블 세팅
CREATE TABLE applyment (
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME,
    updateDate DATETIME,
    memberId INT(10) UNSIGNED NOT NULL,
    relTypeCode CHAR(20) NOT NULL,
    relId INT(10) UNSIGNED NOT NULL,
    delDate DATETIME,
	delStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
	displayStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
    `body` TEXT NOT NULL
);

# 부가정보테이블 
# 댓글 테이블 추가
CREATE TABLE attr (
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    `relTypeCode` CHAR(20) NOT NULL,
    `relId` INT(10) UNSIGNED NOT NULL,
    `typeCode` CHAR(30) NOT NULL,
    `type2Code` CHAR(30) NOT NULL,
    `value` TEXT NOT NULL
);

# attr 유니크 인덱스 걸기
## 중복변수 생성금지
## 변수찾는 속도 최적화
ALTER TABLE `attr` ADD UNIQUE INDEX (`relTypeCode`, `relId`, `typeCode`, `type2Code`); 

## 특정 조건을 만족하는 회원 또는 게시물(기타 데이터)를 빠르게 찾기 위해서
ALTER TABLE `attr` ADD INDEX (`relTypeCode`, `typeCode`, `type2Code`);

# member 테이블에 테스트 데이터 삽입
INSERT INTO `member`
SET regDate = NOW(),
updateDate = NOW(),
loginId = 'user1',
loginPw = SHA2('user1', 256),
`name` = '캐스팅디렉터',
`nickname` = '캐스팅디렉터',
`email` = '',
`cellphoneNo` = '';

INSERT INTO `member`
SET regDate = NOW(),
updateDate = NOW(),
loginId = 'user2',
loginPw = SHA2('user2', 256),
`name` = '김성훈',
`nickname` = '하정우',
`email` = '',
`cellphoneNo` = '';

# 신청테이블에 숨김여부 칼럼을 추가한다.
ALTER TABLE `applyment` ADD COLUMN `hideStatus` TINYINT(1) UNSIGNED DEFAULT 0 NOT NULL AFTER `delStatus`; 

# 작품 테이블 만들기
CREATE TABLE artwork (
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    `name` CHAR(50) NOT NULL,
    `productionName` CHAR(50) NOT NULL,
    `directorName` CHAR(50) NOT NULL,
    etc TEXT
);

INSERT INTO artwork
SET regDate = NOW(),
updateDate = NOW(),
`name` = '균',
`directorName` = '조용선',
productionName = '마스터원엔터테인먼트';

# 배역 테이블 만들기
CREATE TABLE actingRole (
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    artworkId INT(10) UNSIGNED NOT NULL,
    realName CHAR(50) NOT NULL,
    `name` CHAR(50) NOT NULL,
    pay CHAR(50) NOT NULL,
    age CHAR(50) NOT NULL,
    job CHAR(100) NOT NULL,
    scriptStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
    gender CHAR(5) NOT NULL,
    scenesCount TINYINT(2) UNSIGNED NOT NULL DEFAULT 0,
    shootingsCount TINYINT(2) UNSIGNED NOT NULL DEFAULT 0,
    `character` TEXT,
    etc TEXT
);

INSERT INTO actingRole
SET regDate = NOW(),
updateDate = NOW(),
artworkId = 1,
realName = '',
`name` = '조대표',
`job` = '오투 CEO',
pay = '',
age = '',
scriptStatus = 1,
gender = '',
scenesCount = '14',
shootingsCount = '8',
`character` = '오투 한국지사 CEO. 영국국적을 가지고 있고 가습기 살균제 사건을 막기 위해 우식을 TFI 부서 로 복직시킨다. 자신의 이익만을 생각한다.',
etc = '';

ALTER TABLE `recruitment` ADD COLUMN `completeStatus` TINYINT(1) UNSIGNED DEFAULT 0 NOT NULL AFTER `addi`, ADD COLUMN `completeDate` DATETIME AFTER `completeStatus`;

ALTER TABLE `recruitment` ADD COLUMN `roleTypeCode` CHAR(50) NOT NULL AFTER `completeDate`, ADD COLUMN `roleId` INT(10) UNSIGNED NOT NULL AFTER `roleTypeCode`; 

DELETE FROM actingRole
WHERE id = 1;

ALTER TABLE `actingRole` ADD COLUMN `auditionStatus` TINYINT(1) UNSIGNED DEFAULT 0 NOT NULL AFTER `scriptStatus`;

ALTER TABLE `actingRole` CHANGE `scenesCount` `scenesCount` CHAR(10) NOT NULL;
ALTER TABLE `actingRole` CHANGE `shootingsCount` `shootingsCount` CHAR(10) NOT NULL; 

ALTER TABLE `actingRole` CHANGE `realName` `realName` CHAR(50) DEFAULT '' NOT NULL;
ALTER TABLE `actingRole` CHANGE `pay` `pay` CHAR(50) DEFAULT '' NOT NULL;
ALTER TABLE `actingRole` CHANGE `age` `age` CHAR(50) DEFAULT '' NOT NULL;
ALTER TABLE `actingRole` CHANGE `job` `job` CHAR(100) DEFAULT '' NOT NULL;
ALTER TABLE `actingRole` CHANGE `gender` `gender` CHAR(5) DEFAULT '' NOT NULL;
ALTER TABLE `actingRole` CHANGE `scenesCount` `scenesCount` CHAR(10) DEFAULT '' NOT NULL;
ALTER TABLE `actingRole` CHANGE `shootingsCount` `shootingsCount` CHAR(10) DEFAULT '' NOT NULL;

#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Table 1

#1
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, age, job, `character`, scenesCount, scriptStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '정태훈', '40대후반', '의사', '대학병원의 외상센터 의사. 생활은 늘 병원에서만 하던 그에게 갑작스럽게 찾아온 아들의 쓰러 짐 집에 다녀오겠다던 아내의 죽음. 갑작스럽기도 하고 이상하기만 한 아내의 죽음을 파해치기 위해 가습기 살균제에 대해 파해치기 시작한다.', '58(81)씬', 1, 27, NULL);

#2
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, age, job, `character`, scenesCount, scriptStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '한영주', '30대초반', '검사', '서울지검 검사. 서울지검의 소문난 꼴통. 조사중 걸려온 형부의 전화 싸늘하게 있는 언니의 시신 을 발견하고 6개월전 건강검진때는 멀쩡했다며 언니의 죽을을 의심한다. 태훈이 죽음에 대해 밝 혀내는것을 도와주기위해 함께 방문조사도 다니며 가습기 살균제의 유해성에 대해 밝혀나간다.', '41(49)씬', 1, 23, NULL);

#3
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, age, job, `character`, scenesCount, scriptStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '서우식', '40대중반', '오투팀장', '오투 TFI 00. 오투의 부름을 받고 휴직을 끝내고 회사로 복귀하는 우식. 가습기 살균제 사건을 막기위해 피해자들과 합의를 진행하고 상황을 막기위해 힘쓴다. 하지만 그도 가습기 살균제 피 해자의 가족이였다.', '34(44)씬', 1, 20, NULL);

#4
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, age, job, `character`, scenesCount, scriptStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '한길주', '40대중반', '주부', '태훈의 아내이자 민우의 엄마. 갑작스럽게 민우가 쓰러지자 당황하는 길주. 민우의 짐을 가지러 가기위해 집에 가지만 민우와 같은 증상으로 사망에 이르게 된다.', '15(18)씬', 1, 7, NULL);

#5
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, job, `character`, scenesCount, scriptStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '조대표', '오투CEO', '오투 한국지사 CEO. 영국국적을 가지고 있고 가습기 살균제 사건을 막기 위해 우식을 TFI 부서 로 복직시킨다. 자신의 이익만을 생각한다.', '14씬', 1, 8, NULL);

#6
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`,job, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '인호', '의사', '태훈의 병원 동료. 태훈과 함께 민우의 죽음에 대해 파해친다.', '23(28)씬', 1, 0, 16, NULL);

#7
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, job, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '현종', '치킨집사장', '가습기 살균제 피해자의 가족. 아내와 쌍둥이를 위해 열심히 치킨집을 하지만 갑작스러운 아내 와 쌍둥이의 죽음 원인을 제대로 알지 못한 의사를 불신한다. 하지만 태훈이 찾안낸 아내와 쌍둥 이의 죽음이 가습기 살균제라는 사실을 알게된 후 다른 피해자들과 오투와 맞써지만 가족들의 수술비를 위해 지인들이 보증을 서주면서 마련한 돈에 의해 오투와 합의를 한다.', '10씬', 1, 0, 7, NULL);

#8
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, job, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '순영모', '주부', '가습기살균제 피해자의 엄마. 최근 폐질환 판정을 받았다. 2년동안 감기인줄만 알고 기침을 달 고살았다.', '12씬', 1, 0, 5, NULL);

#9
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, age, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '정민우', '7세', '태훈의 아들. 가습기살균제 피해자.', '17씬', 1, 0, 10, NULL);

#10
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, job, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '정민우', '16', '태훈의 아들. 가습기살균제 피해자.', '1씬', 1, 0, 1, NULL);

#11
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, job, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '정경한', '대형로펌변호사', '오투의 변호사. 대형로펌의 잘나가는 변호사. 은퇴하는 법조계 사람들의 워너비이다.', '6(7)씬', 1, 0, 4, NULL);

#12
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '은정', '우식의 아내. 가습기살균제 피해자. 폐질환으로 죽은 민지가 자신의 슬픔을 이기지 못하고 자살 한다.', '3(5)씬', 1, 0, 3, NULL);

#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Table 2

#13
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, age, job, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '양계장', '40대', '계장', '영주 검사실의 계장. 영주와 함께 일하며 영주가 가습기 살균제 피해자들을 위해 변호사를 할때 서울지검에서 같이 나와 가습기 살균제 피해자를 위해 일한다.', '11(15)씬', 1, 0, 11, NULL);

#14
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, job, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '부장검사', '검사', '서울지검 부장검사. 영주를 믿는 검사. 하지만 위에서 내려오는 압박에 영주를 막는다. 하지만 그 압박이 덜해지자 다시 영주를 서울지검으로 불러낸다.', '4씬', 1, 0, 3, NULL);

#15
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, job, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '판사', '판사', '법정판사. 경한에게 잘보이기 위해 오투의 편에서서 재판을하는 판사.', '3씬', 1, 0, 3, NULL);

#16
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, job, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '추성모', '독성실험박사', '가습기 살균제에서 안좋은 성분이 나온것을 알고 우식을 협박한후 오투에게 좋은 방향으로 가습 기 살균제 독성실험검사를 조작하는 박사.', '4씬', 1, 0, 3, NULL);

#17
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, job, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '장교수', '화학계통전문가', '피해자들을 도와주기위해 전문가로써 증인석에 서지만 오히려 피해만 되는 장교수 그 또한 오투 에 매수된 사람.', '3씬', 1, 0, 3, NULL);

#18
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, job, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '김기자', '기자', '오투에게 뒷돈을 받고 오투를 위해 오투에 나쁜 기사를 막고 좋은 기사를 써주는 기자.', '6(8)씬', 1, 0, 5, NULL);

#19
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, job, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '박의원', '의원', '오투에게 뒷돈을 받고 오투를 위해 자신의 지위를 이용해 도와주는 의원.', '3씬', 1, 0, 3, NULL);

#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Table 3

#20
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, age, gender, job, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '김실장', '40대', '남', '오투대표비서', '조대표를 보좌하는 비서.', '8(11)씬', 1, 1, 7, '오디션');

#21
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, age, gender, job, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '이대리', '30대', '남', '우식비서', '우식을 보좌하는 대리. 비상TF팀에 발령 받고 우식을 돕는 대리.', '15씬', 1, 1, 10, '오디션');

#22
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, age, job, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '남변호사', '40대', '이혼전문변호사', '이혼전문변호사. 영주의 부탁을 듣고 길주와 상담을 한다.', '1씬', 1, 1, 1, NULL);

#23
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, age, gender, job, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '남레지던트', '30대초반', '남', '의사', '태훈의 직장동료. 병원의 남레지던트.', '4(6)씬', 1, 1, 3, '오디션');

#24
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, age, gender, job, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '여레지던트', '20대후반', '여', '의사', '태훈의 직장동료. 병원의 여레지던트.', '4(6)씬', 1, 1, 3, '오디션');

#25
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, age, gender, job, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '남의사', '40대', '남', '의사', '태훈의 직장동료. 병원의 남의사.', '2씬', 1, 1, 2, '오디션');

#26
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, age, gender, job, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '여의사', '30대', '여', '의사', '태훈의 직장동료. 병원의 여의사.', '2씬', 1, 1, 2, '오디션');

#27
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, age, gender, job, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '여 실무관', '30대', '여', '검사 실무관', '영주의 검사 사무실의 여성 실무관.', '2씬', 1, 1, 2, '오디션');

#28
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, gender, job, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '오교수', '남', '오의원 원장', '최초로 봄마다 발생하는 폐질환을 발견하시고 오랫동안 연구한 교수.', '2(3)씬', 1, 1, 2, '캐스팅');

#29
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, age, gender, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '아이아빠', '40대', '남', '과거 오교수의 멱살을 잡으며 죽은 아이를 살려내라고 하는 아빠.', '1씬', 1, 1, 1, '오디션');

#30
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, age, gender, job, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '의료진', '40대', '남', '의사', '과거 오교수와 함께 숨진아이의 부모 앞에 고개를 숙이고 있는 의사.', '2씬', 1, 1, 2, '오디션');

#31
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, age, gender, job, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '순영', '30대중반', '여', '전직배구선수', '전직 배구선수. 가습기 살균제의 피해자. 호흡기에 의존하며 살아가고있다.', '3씬', 1, 1, 2, '오디션');

#32
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, age, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '종합병원 관계자', '30대후반', '종합병원의 관계자. 폐질환 때문에 미혼모인 엄마가 죽고 홀로 인큐베이터에서 살아보겠다고 몸 부림치는 신생아의 이야기를 전해주는 병원관계자', '1씬', 1, 1, 1, '오디션');

#33
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, age, gender, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '질본연구원', '30대후반', '남', '질병본부 연구원. 태훈의 집에 질병을 검사한다.', '2씬', 1, 1, 2, '오디션');

#34
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, age, gender, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '질본본부장', '40대후반', '남', '질병본부 본부장. 태훈집의 검사 결과를 알려준다.', '2씬', 1, 1, 2, '오디션');

#35
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, age, gender, job, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '부사장', '50대', '남', '오투부사장', '오투의 부사장. 조대표에게 질책을 받는다.', '1씬', 1, 0, 1, '오디션');

#36
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, age, gender, job, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '여직원', '20대', '여', '오투로비여직원', '오투 본사 로비에 찾아온 현종을 막는 여직원. "(행색을 훑으며) 무슨 일이시죠?"', '1씬', 1, 1, 1, '오디션');

#37
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, age, gender, job, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '의원1', '60대', '남', '국회의원', '박의원을 따라 부장검사를 찾아가 대화를 나누는 국회의원.\n"아! 일부에서 서울지검 한영주 검사가 자신의 지위를 이용해 불법수사 했다는 이야기가 나오던 데 어떻게 된 겁니까?"', '1씬', 1, 1, 1, '오디션');

#38
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, age, gender, job, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '의원2', '60대', '남', '국회의원', '박의원을 따라 부장검사를 찾아가 대화를 나누는 국회의원. "만약 사실로 밝혀지면 확실하게 징계할 거죠?"', '1씬', 1, 1, 1, '오디션');

#39
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, age, gender, job, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '의원3', '60대', '남', '국회의원', '박의원을 따라 부장검사를 찾아가 대화를 나누는 국회의원.\n"(버럭) 그게 지금 무슨 말입니까?? 그럼 수사결과가 좋으면 불법 수사해도 상관없다. 뭐 이런 말입니까~?? 이러니까 검찰이 안 좋은 소리를 듣는 거예요!!"', '1씬', 1, 1, 1, '오디션');

#40
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, age, gender, job, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '법원관계자', '40대', '남', '법원행정차장', '경한의 후배. 경한에게 검찰이 기소하지 않는 이상 피해자들이 할수 있는 방법은 개별 소송밖에 없다고 하며 무조건 선배가 이긴다고 말하는 관계자.\n"선배님, 너무 걱정하지 마십시오. 검찰이 기소하지 않는 이상 이제 저쪽에서 할 수 있는 방법이 라곤 개별 소송밖에 없습니다. 그런데 그 개별 소송으로 선배님을 이긴다? 이건 나라가 망하지 않는 이상, 거의 불가능에 가깝죠!"', '1씬', 1, 1, 1, '오디션');

#41
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '여기자', '가습기 살균제 피해자와 오투와의 첫 재판을 재판장 앞에서 브리핑하는 기자.\n"잠시 후 오후 2시부터 이곳 서울지방법원에서 가습기살균제 깔끔이에 대한 첫 재판이 예정되어 있습니다. 이번 재판에서 쟁점이 될 흡입독성을 두고, 시작 전부터 양측이 팽팽하게 맞섰던 만 큼, 매우 치열한 공방이 예상되는데요…"', '1씬', 1, 1, 1, '오디션');

#42
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, job, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '법원직원', '공판진행자', '재판을 진행하며 안내해주는 법원직원.', '1씬', 1, 1, 1, '오디션');

#43
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, age, gender, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '현종엄마', '70대', '여', '치매를 앓고 있는 현종의 엄마.', '1씬', 1, 0, 1, NULL);

#44
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, age, gender, job, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '연구원1', '30대후반', '남', '독성물질 연구원', '추성모 박사 밑에서 일하는 연구원.\n추성모 박사의 지시에 따라 독성실험을 진행한다.', '1씬', 1, 1, 1, '오디션');

#45
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, age, gender, job, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '연구원2', '30대후반', '남', '독성물질 연구원', '추성모 박사 밑에서 일하는 연구원.\n추성모 박사의 지시에 따라 독성실험을 진행한다.', '1씬', 1, 1, 1, '오디션');

#46
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, job, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '피해자1', '가습기살균제 피해자', '가습기살균제 피해자.\n"이제 어떡할 거야?? 오투에서 손해배상 청구한다는데!!"', '4씬', 1, 1, 4, '오디션');

#47
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, job, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '피해자2', '가습기살균제 피해자', '가습기살균제 피해자.\n"안 그래도 먹고사는 게 힘들어 죽겠는데!! 이러려고 우리 찾아와서 소송하자고 했어요?"', '4씬', 1, 1, 4, '오디션');

#48
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, job, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '피해자3', '가습기살균제 피해자', '가습기살균제 피해자. "무슨 말씀 좀 해보세요??"', '4씬', 1, 1, 4, '오디션');

#49
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, job, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '피해자4', '가습기살균제 피해자', '가습기살균제 피해자.\n"(물을 뿌리며) 집어 치워!! 합의만 했어도 돈이 얼만데... 다 당신 책임이야!! 당신이 책임지라고
~!!"', '4씬', 1, 1, 4, '오디션');

#50
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, age, gender, job, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '형사', '40대', '남', '형사', '조대표를 검거하는 형사.', '1씬', 1, 1, 1, '오디션');

#51
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, age, gender, job, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '직원', '20대', '여', '병원직원', '우식에게 민지와 은정이 있는곳을 안내해주는 병원직원.', '1씬', 1, 1, 1, '오디션');

#52
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, age, gender, job, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '의사', '40대', '남', '의사', '대학병원 의사. 집중치료실에 있는 은정의 상태를 설명해주는 의사.', '1씬', 1, 1, 1, '오디션');

#53
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, age, gender, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '장모', '70대', '여', '화장터에서 민지의 죽음에 슬퍼하는 장모. "아이고 안 된다. 안 된다. 우리 아가…"', '1씬', 1, 0, 1, NULL);

#54
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, age, gender, job, `character`, scenesCount, scriptStatus, auditionStatus, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '상관', '50대', '남', '오투직원', '오투 본사 직원. 당분간 쉬고싶다는 우식에게 호주 수출건만 정리해달라는 상관.', '1씬', 1, 0, 1, NULL);

#55
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, scenesCount, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '남앵커', '1씬', 1, NULL);

#56
INSERT INTO actingRole (regDate, updateDate, artworkId, `name`, scenesCount, shootingsCount, etc)
VALUES (NOW(), NOW(), 1, '여앵커', '1씬', 1, NULL);

# attr에 만료날짜 추가
ALTER TABLE `attr` ADD COLUMN `expireDate` DATETIME NULL AFTER `value`;

# file에 fileDir 추가
ALTER TABLE `file` ADD COLUMN `fileDir` CHAR(20) NOT NULL AFTER `body`; 