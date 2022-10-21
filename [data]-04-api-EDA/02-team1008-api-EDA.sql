--  테이블 명 : team_1008
--  테이블 설명 : 넥슨 API에서 수집한 카트라이더 스피드 팀전 매치, 유저 데이터
--  수집 기간 : 2022-10-08 00:00:00 ~ 2022-10-08 23:58:00

USE kart_data_test;

# 1. EDA
# (1) 주요 데이터 확인
--  매치 건 수 : 500개
--  유저 수 : 749명(게임 플레이 중간에 나간 유저도 포함)
--  매치에서 사용 된 트랙 수 : 147개

# 매치 건 수 : 500개
SELECT COUNT(DISTINCT matchId)
FROM team_1008;

# 유저 수 : 749명
-- 게임 플레이 중간에 나간 유저도 포함된 숫자 
SELECT COUNT(DISTINCT accountNo)
FROM team_1008;

# 매치에서 사용 된 트랙 수 : 147개
SELECT COUNT(DISTINCT trackId)
FROM team_1008;


-- ---------------------------------------------------

# (2) licensce는 항상 ""를 가진다.
# 검증 결과 : 검증완료(license 삭제해도 된다)
SELECT license
FROM team_1008
WHERE license !=" ";

-- ---------------------------------------------------

# (3) rankinggrade2는 플레이어의 라이센스로 0~5가 있다. 

# (3).1 rankinggrade2는 플레이어의 라이센스로 0은 없음, 1~6은 초보부터 pro까지, 게임 종료시 ""
# 검증결과 : 0~5가 있다.
SELECT DISTINCT rankinggrade2
FROM team_1008
ORDER BY 1;

# (3).2 rankinggrade2 0이 게임 종료 한 사람이라면, matchwin이 ""이어야한다.
# 검증 결과 : 0인데도, matchwin이 1이고 matchTime이 있는 걸보니 게임 종료는 아닌 것 같다.
SELECT *
FROM team_1008
WHERE rankinggrade2 = 0;

-- ---------------------------------------------------

# (4) matchRank는 해당 매치에서의 순위로 1~8이 있고, 리타이어시 99, 게임 종료 시 0 이다.
#(4).1 해당 매치에서의 순위, 리타이어시 99, 게임 종료시“”
# 검증결과 -> 0,99,1~8까지 있다.
SELECT DISTINCT matchRank
FROM team_1008
ORDER BY 1;

#(4).2 99가 리타이어라면, matchRetired가 1일 것이다.
# 검증 : 검증 완료, 99인 경우만 matchRetired가 1이다.
SELECT DISTINCT matchRetired
FROM team_1008
WHERE matchRank=99;

SELECT DISTINCT matchRetired
FROM team_1008
WHERE matchRank!=99;

#(4).3 0이 게임 종료라면, matchTime, matchRetired, matchWin이 0이다.
# 검증 :matchTime은 null값인데, 0으로 바꿔줄 필요가 있고, matchRetired, matchWin은 0이다. -> speed_1008과 다른점이다.
SELECT DISTINCT matchTime
FROM team_1008
WHERE matchRank=0;

SELECT DISTINCT matchRetired
FROM team_1008
WHERE matchRank=0;

SELECT DISTINCT matchWin
FROM team_1008
WHERE matchRank=0;

#(4).4 matchTime은 null값인데, 0으로 했을 때 출력된다. single_1008은 matchTime이 double이고 team_1008은 text여서 발생한 문제인 것 같다. 
SELECT *
FROM team_1008
WHERE matchTime=0;

SELECT *
FROM team_1008
WHERE matchTime IS NULL;

-- ---------------------------------------------------

# (5). matchRetired가 1이면(리타이어 시), matchTime이 0이다. (얘도 동일하게 NULL값이 0으로 잡힌다)
# 검증 결과 : 검증완료
SELECT DISTINCT matchTime
FROM team_1008
WHERE matchRetired=1;

SELECT DISTINCT matchRetired
FROM team_1008
WHERE matchTime IS NULL;

-- ---------------------------------------------------

# (6). matchWin은 승리는 1, 패배 or 게임 종료는 0이다.
-- 게임 종료 한 유저도 matchWin이 0이기 때문에, matchWin = 0 인 유저 중에 패배한 유저만 보려면 matchRank가 0이 아닌(게임 종료 유저를 제외하는) 조건을 걸어줘야한다.

#(6)-1. matchWin은 승리는 1, 패배는 0, 게임 종료시 ""
#검증 결과 : 1과 0만 있다.
SELECT DISTINCT matchwin
FROM team_1008;

-- ---------------------------------------------------

# (7). matchTime은 같은 matchid더라도 순위에 따라 다르게 나오는 값이다. 
--  마지막 3자리가 밀리세컨드 부분, 그 앞에는 시, 분 ,초의 값이다.
--  밀리세컨드 단위로 순위가 많이 갈린다. 

#검증결과 : 검증 완료
SELECT matchRank, characterName, matchRetired, matchWin,matchTime 
FROM team_1008
ORDER BY 1;

-- ---------------------------------------------------

# (8). characterName과 accountNo는 고유한 값이다.
#검증결과 : 검증 완료
SELECT COUNT(DISTINCT characterName), COUNT(DISTINCT accountNo)
FROM team_1008;