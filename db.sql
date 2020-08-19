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
DROP TABLE IF EXISTS attr;
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


