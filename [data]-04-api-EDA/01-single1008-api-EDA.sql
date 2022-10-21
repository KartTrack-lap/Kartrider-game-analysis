--  테이블 명 : single_1008
--  테이블 설명 : 넥슨 API에서 수집한 카트라이더 스피드 개인전 매치, 유저 데이터
--  수집 기간 : 2022-10-08 00:00:00 ~ 2022-10-08 23:58:00

USE kart_data_test;

# 1. EDA
# (1) 주요 데이터 확인
--  매치 건 수 : 1240개
--  유저 수 : 1153명(게임 플레이 중간에 나간 유저도 포함)
--  1240개의 매치에서 사용 된 트랙 수 : 216개

# 매치 건 수 : 1240개
SELECT COUNT(DISTINCT matchId)
FROM single_1008;

# 유저 수 : 1153명
-- 게임 플레이 중간에 나간 유저도 포함된 숫자 
SELECT COUNT(DISTINCT accountNo)
FROM single_1008;

# 1240개의 매치에서 사용 된 트랙 수 : 216개
SELECT COUNT(DISTINCT trackId)
FROM single_1008;


-- ---------------------------------------------------

# (2) licensce는 항상 ""를 가진다.
# 검증 결과 : 검증완료(license 삭제해도 된다)
SELECT license
FROM single_1008
WHERE license !=" ";

-- ---------------------------------------------------

# (3) rankinggrade2는 플레이어의 라이센스로 0~5가 있다. 

# (3).1 rankinggrade2는 플레이어의 라이센스로 0은 없음, 1~6은 초보부터 pro까지, 게임 종료시 ""
# 검증결과 : 0, 1~5가 있다.
SELECT DISTINCT rankinggrade2
FROM single_1008
ORDER BY 1;

# (3).2 rankinggrade2 0이 게임 종료 한 사람이라면, matchwin이 ""이어야한다.
# 검증 결과 : 0인데도, matchwin이 1이고 matchTime이 있는 걸보니 게임 종료는 아닌 것 같다.
SELECT *
FROM single_1008
WHERE rankinggrade2 = 0;

-- ---------------------------------------------------

# (4) matchRank는 해당 매치에서의 순위로 1~8이 있고, 리타이어시 99, 게임 종료 시 0 이다.
#(4).1 해당 매치에서의 순위, 리타이어시 99, 게임 종료시“”
# 검증결과 -> 0,99,1~8까지 있다.
SELECT DISTINCT matchRank
FROM single_1008
ORDER BY 1;

#(4).2 99가 리타이어라면, matchRetired가 1일 것이다.
# 검증 : 검증 완료, 99인 경우만 matchRetired가 1이다.
SELECT DISTINCT matchRetired
FROM single_1008
WHERE matchRank=99;

SELECT DISTINCT matchRetired
FROM single_1008
WHERE matchRank!=99;

#(4).3 0이 게임 종료라면, matchTime, matchRetired, matchWin이 0이다.
# 검증 : 검증 완료

SELECT DISTINCT matchTime
FROM single_1008
WHERE matchRank=0;

SELECT DISTINCT matchRetired
FROM single_1008
WHERE matchRank=0;

SELECT DISTINCT matchWin
FROM single_1008
WHERE matchRank=0;

-- ---------------------------------------------------

# (5). matchRetired가 1이면(리타이어 시), matchTime이 0이다.
# 검증 결과 : 검증완료
SELECT DISTINCT matchTime
FROM single_1008
WHERE matchRetired=1;


-- ---------------------------------------------------

# (6). 개인전이기 때문에, matchWin이 1(승리)이면, matchRank는 1일 것인데 아닌게 있어서 검증해줘야한다.

#(6)-1. matchWin은 승리는 1, 패배는 0, 게임 종료시 ""
#검증 결과 : 1과 0만 있다.
SELECT DISTINCT matchwin
FROM single_1008;

#(6)-2. 개인전이기 때문에, matchWin이 1(승리)이면, matchRank는 1일 것이다.
#검증 결과 : matchRank에 1~7,99값이 있다. 
#확인 해야하는 내용 -> 1. 개인전 데이터가 잘 들어간 건지 확인해본다. 잘들어갔지만, 이렇게 나온거라면 matchRank가 1인 값 만 matchwin이 1이 되도록 바꿔준다.
SELECT DISTINCT matchRank
FROM single_1008
WHERE matchwin = 1;


#(6)-3.matchId에 개인전이 잘 들어간 건지 matchId를 넥슨 api홈페이지에서 검색해서 검증 
# matchRank가 1이 아닌데, matchwin이1이 있는 matchId 02d30001026abfa8, 03a00001026b348a, 028f0001026b41e8
#검증 결과 : 3개 모두 channelName": "battle",  "matchResult": "2" -> 아이템배틀(가장빠름) , 블루팀 승리 로 나온걸 보아 개인전만 들어간게 아닌 것 같음

#(6)-4. (6)-2와 (6)-(3)이 해결된다면, "matchWin이 1(승리)이면, matchRank는 1이고, matchWin은 승리는 1, 패배 or 게임 종료는 0이다"를 검증해보자
#게임 종료 한 유저도 matchWin이 0으로 나오면, matchWin = 0 인 유저 중에 패배한 유저만 보려면 matchRank가 0이 아닌(게임 종료 유저를 제외하는) 조건을 걸어줘야한다.


-- ---------------------------------------------------

# (7). matchTime은 같은 matchid더라도 순위에 따라 다르게 나오는 값이다. 
--  마지막 3자리가 밀리세컨드 부분, 그 앞에는 시, 분 ,초의 값이다.
--  밀리세컨드 단위로 순위가 많이 갈린다. 


#검증결과 : 검증 완료
SELECT matchRank, characterName, matchRetired, matchWin,matchTime 
FROM single_1008
WHERE matchId = "02310018024ac90a"
ORDER BY 1;

-- ---------------------------------------------------

# (8). characterName과 accountNo는 고유한 값이다.
#검증결과 : 검증 완료
SELECT COUNT(DISTINCT characterName), COUNT(DISTINCT accountNo)
FROM single_1008;