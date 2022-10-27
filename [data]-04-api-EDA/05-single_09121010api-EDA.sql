--  테이블 명 : single_0912_1010
--  테이블 설명 : 넥슨 API에서 수집한 카트라이더 개인전 매치, 유저 데이터
--  수집 기간 : 2021-09-12 00:00:00 ~ 2022-10-10 00:00:00

USE kart_data_test;

SELECT *
FROM single_0912_1010
Limit 100;

# (1) matchtype확인
# 결과 : 
# 1. {"id":"7b9f0fd5377c38514dbb78ebe63ac6c3b81009d5a31dd569d1cff8f005aa881a","name":"스피드 개인전"}
# 2. {"id":"7ca6fd44026a2c8f5d939b60aa56b4b1714b9cc2355ec5e317154d4cf0675da0","name":"아이템 개인전"}
# 3. {"id":"ee2426e23fa56f7a695084e1fc07fe6bb03a0b3b0c71c4e1f1b7e7e78e6c6878","name":"아이템 팀 배틀모드"}
# 4. Null
SELECT DISTINCT matchtype
FROM single_0912_1010;

# (1)-1 스피드 개인전 매치 건수 : 98,194건
SELECT COUNT(DISTINCT matchId)
FROM single_0912_1010
WHERE matchtype ='7b9f0fd5377c38514dbb78ebe63ac6c3b81009d5a31dd569d1cff8f005aa881a';

# (1)-2 아이템 개인전 매치 건수 : 48,804건
SELECT COUNT(DISTINCT matchId)
FROM single_0912_1010
WHERE matchtype ='7ca6fd44026a2c8f5d939b60aa56b4b1714b9cc2355ec5e317154d4cf0675da0';

# (1)-3 아이템 팀 배틀모드매치 건수 : 8,223건
SELECT COUNT(DISTINCT matchId)
FROM single_0912_1010
WHERE matchtype ='ee2426e23fa56f7a695084e1fc07fe6bb03a0b3b0c71c4e1f1b7e7e78e6c6878';

# (1)-4 NULL : 5,965건
SELECT COUNT(DISTINCT matchId)
FROM single_0912_1010
WHERE matchtype IS NULL;

-- 어떤 모드인지 특정할 수 없기 때문에 고려하지 않기로 결정
SELECT *
FROM single_0912_1010
WHERE matchtype IS NULL
LIMIT 100;


# 2. 스피드 개인전 테이블 생성 
CREATE TABLE single_speed_0912_1010
SELECT *
FROM single_0912_1010
WHERE matchtype ='7b9f0fd5377c38514dbb78ebe63ac6c3b81009d5a31dd569d1cff8f005aa881a';

# (1) 주요 데이터 확인
# 매치 건 수 :  98,194건
# 유저 수 : 65,913명
# 매치에서 사용 된 트랙 수 : 326개

# 매치 건 수 :  98,194건
SELECT COUNT(DISTINCT matchId)
FROM single_speed_0912_1010;

# 시작 날짜 별 매치 건수 : 3,600~4,500건 정도 추출
SELECT left(start,10) as strat_date, COUNT(DISTINCT matchId)
FROM single_speed_0912_1010
GROUP BY 1;


# 유저 수 : 65,913명
SELECT COUNT(DISTINCT accountNo)
FROM single_speed_0912_1010;


# 매치에서 사용 된 트랙 수 : 326개
SELECT COUNT(DISTINCT trackId)
FROM single_speed_0912_1010;


-- ---------------------------------------------------

# (2) match_start_time과 match_end_time -> 확인 필요

# (2)-1 match_end_time-match_start_time은 1등 matchtime도 아니고, 꼴등 matchtime도 아니다. 
SELECT match_start_time, match_end_time, matchTime, matchRank, matchId
FROM single_speed_0912_1010
WHERE matchRank=8;

-- ---------------------------------------------------
# (3) acountNo에 음수 값이 없다. 
SELECT DISTINCT accountNo
FROM single_speed_0912_1010
ORDER BY 1 ASC;

-- ---------------------------------------------------
# (4) 유저 수는 accountNo로 계산해야한다. 
-- 동일한 accountNo에 characterName이 여러개 인 경우가 있다. 

# (4)-1 characterName 1개 당 accountNo는 1개다.
# 검증 결과 : characterName : 68136, accountNO : 65913 이다. 
SELECT COUNT(DISTINCT characterName), COUNT(DISTINCT accountNo)
FROM single_speed_0912_1010;

# (4)-2 accountNo는 동일한데, characterName이 1개 이상인 경우가 있다.
# 닉네임을 바꾼 경우가 이에 해당하는 값인 것 같다. 
SELECT accountNo, COUNT(DISTINCT characterName) AS cnt
FROM single_speed_0912_1010
GROUP BY 1
ORDER BY 2 DESC;

SELECT DISTINCT characterName, match_start_time, match_end_time
FROM single_speed_0912_1010
WHERE accountNo=1325969169;

# (4)-3 동일한 characterName을 가지면 accountNo가 1개이다. 
-- characterName 1개 당 accountNo는 1개 이다.
SELECT characterName, COUNT(DISTINCT accountNo) AS cnt
FROM single_speed_0912_1010
GROUP BY 1
ORDER BY 2 DESC;

-- ---------------------------------------------------


# (5) licensce는 항상 ""를 가진다.
# 검증 결과 : 검증완료(license 삭제해도 된다)
SELECT DISTINCT license
FROM single_speed_0912_1010;

-- ---------------------------------------------------

# (6) rankinggrade2는 플레이어의 라이센스로 0은 없음, 1~6은 초보부터 pro까지이다.

# (6)-1 rankinggrade2는 플레이어의 라이센스로 0은 없음, 1~6은 초보부터 pro까지, 게임 종료시 ""
# 검증결과 : 0, 1~6가 있다.
SELECT DISTINCT rankinggrade2
FROM single_speed_0912_1010
ORDER BY 1;


-- ---------------------------------------------------

# (7) matchRank는 해당 매치에서의 순위로 1~8이 있고, 리타이어시 99, 게임 종료 시 0 이다.
#(7).1 해당 매치에서의 순위, 리타이어시 99, 게임 종료시“”
# 검증결과 -> 0,99,1~8까지 있다.
SELECT DISTINCT matchRank
FROM single_speed_0912_1010
ORDER BY 1;

#(7)-2 99가 리타이어라면, matchRetired가 1일 것이다.
# 검증 : 검증 완료, 99인 경우만 matchRetired가 1이다.
SELECT DISTINCT matchRetired
FROM single_speed_0912_1010
WHERE matchRank=99;

SELECT DISTINCT matchRetired
FROM single_speed_0912_1010
WHERE matchRank!=99;


#(7)-3 0이 게임 종료라면, matchTime과 matchWin은 null이고 matchRetired은 0이다.
# 검증 :확인 완료, 0은 게임 종료다
SELECT DISTINCT matchTime
FROM single_speed_0912_1010
WHERE matchRank=0;

SELECT DISTINCT matchRetired
FROM single_speed_0912_1010
WHERE matchRank=0;

SELECT DISTINCT matchWin
FROM single_speed_0912_1010
WHERE matchRank=0;


-- ---------------------------------------------------

# (5). matchRetired가 1이면(리타이어 시), matchTime이 NULL이다.
# 검증 결과 : 검증완료
SELECT DISTINCT matchTime
FROM single_speed_0912_1010
WHERE matchRetired=1;


-- ---------------------------------------------------

# (6). 리타이어된 사람과 중간에 이탈한 사람으로 구성된 match를 제거해 줄지 결정 필요

#(6)-1. matchWin은 승리는 1, 패배는 0, 게임 종료시 ""
#검증 결과 : 검증 완료
SELECT DISTINCT matchwin
FROM single_speed_0912_1010;

#(6)-2. 개인전이기 때문에, matchWin이 1(승리)이면, matchRank는 1일 것이다.
#검증 결과 : matchRank에 1,99값이 있다. -> matchRank가 99인데 matchwin이 1인 경우 53건이고 나머지 65,528건은 0이다. 
SELECT DISTINCT matchRank
FROM single_speed_0912_1010
WHERE matchwin = 1;

# matchRank가 99인데 matchwin이 1인 경우 53건이고 나머지 65,528건은 0이다. 
SELECT matchWin, count(matchWin)
FROM single_speed_0912_1010
WHERE matchRank = 99
GROUP BY 1;

SELECT *
FROM single_speed_0912_1010
WHERE matchRank = 99
ORDER BY matchWin DESC;

# 위의 경우는 리타이어된 사람과 중간에 이탈한 사람으로 구성된 match이다. 
SELECT *
FROM single_speed_0912_1010
WHERE matchId = '0051000b8c7501a7' ;


-- ---------------------------------------------------

# (7). matchTime은 같은 matchid더라도 순위에 따라 다르게 나오는 값이다. 
--  마지막 3자리가 밀리세컨드 부분, 그 앞에는 시, 분 ,초의 값이다.
--  밀리세컨드 단위로 순위가 많이 갈린다. 

#검증결과 : 검증 완료
SELECT matchRank, characterName, matchRetired, matchWin,matchTime 
FROM  single_speed_0912_1010
ORDER BY 1;

-- ---------------------------------------------------

# (8). start와 end는 match_start_time 기준이다.
#검증결과 : 일부 데이터가 부합하지 않는다.
SELECT match_start_time, match_end_time, start, end
FROM  single_speed_0912_1010
WHERE matchId = '01d2000d16780c1c';

# (9). 부합하지 않는 데이터를 찾아보자
# 검증 결과 : matchId : 00ed000b3df1ab9a, 031d000b6dc5b78d, 031d000b6dc5b78d
SELECT *
,CASE WHEN match_start_time = start_time Then '1' ELSE '0' END AS start_check
,CASE WHEN match_end_time = start_time Then '1' ELSE '0' END AS start_check
FROM (SELECT matchId
	   ,left(match_start_time,10) as match_start_time
	   ,left(match_end_time,10) as match_end_time
       ,left(start,10) as start_time
	   ,left(end,10) as end_time
	  FROM  single_speed_0912_1010) AS T1
order by 2,3;



-- ---------------------------------------------------

# (2) 분석에 필요한 테이블 생성
# 조건 1. 매치의 모든 플레이어의 matchRank가 0 혹은 99인 매치는 완주하지 않은 매치로 간주하고 제외
# 조건 2. start와 end가 match_start_time이 아닌 3건을 제외
# 조건 3. ERD에 맞게 column명 변경

CREATE TABLE single_speed_0912_1010_fin
SELECT T1.matchId AS id
	   ,T2.trackId AS track_id
       ,T2.match_start_time AS start_time
       ,T2.match_end_time AS end_time
       ,T2.accountNo AS user_id
       ,T2.characterName AS user_name
       ,T2.rankinggrade2 AS user_licence
       ,T2.matchRank as match_rank
       ,T2.matchRetired AS retired
       ,T2.matchWin AS record
       ,T2.matchTime AS match_time
       ,T2.matchtype AS match_type_id
FROM
(SELECT matchId
FROM single_speed_0912_1010
WHERE matchRank = 1) AS T1 #완주 한 매치는 matchRank에 1이 존재한다. 
LEFT JOIN 
(SELECT * 
FROM single_speed_0912_1010) AS T2 #matchRank에 1이 존재하는 matchId를 기준으로 LeftJoin해주면, 모든 유저가 완주하지 않는 매치는 포함되지 않는다. 
ON T1.matchId = T2.matchId
WHERE T1.matchId NOT IN ('00ed000b3df1ab9a','031d000b6dc5b78d','031d000b6dc5b78d'); #start와 end가 match_start_time이 아닌 3건을 제외해준다.


# (3) 생성한 테이블을 검증한다. 

#(3)-1 개인전이기 때문에, matchWin이 1(승리)이면, matchRank는 1일 것이다.
#검증 결과 : 검증 완료
SELECT DISTINCT match_rank
FROM single_speed_0912_1010_fin
WHERE record = 1;

#(3)-2 start와 end는 match_start_time 기준이 아닌 데이터가 잘 삭제되었는지 확인한다.
#검증결과 : 검증 완료
SELECT *
FROM single_speed_0912_1010_fin
WHERE id IN ('00ed000b3df1ab9a','031d000b6dc5b78d','031d000b6dc5b78d');

#(4) 주요 데이터 확인
# 매치 건 수 :  81,955건
# 유저 수 : 64,000명
# 매치에서 사용 된 트랙 수 : 326개

# 매치 건 수 :  81,955건
SELECT COUNT(DISTINCT id)
FROM single_speed_0912_1010_fin;

# 시작 날짜 별 매치 건수 : 3,000~3,500건 정도 추출
SELECT left(start_time,10) as strat_date, COUNT(DISTINCT id)
FROM single_speed_0912_1010_fin
GROUP BY 1;

# 유저 수 : 64,000명
SELECT COUNT(DISTINCT user_id)
FROM single_speed_0912_1010_fin;

# 매치에서 사용 된 트랙 수 : 326개
SELECT COUNT(DISTINCT track_id)
FROM single_speed_0912_1010_fin;



# (5) 주요 지표 계산   

# (5)-1 트랙별 사용 건 수 : cnt_match
SELECT T2.map_name, T1.cnt_match
FROM (SELECT track_id, COUNT(DISTINCT id) AS cnt_match
FROM single_speed_0912_1010_fin
GROUP BY 1
ORDER BY 2 DESC) AS T1 
LEFT JOIN track_name AS T2 ON T1.track_id = T2.trackId;

# (5)-2 트랙별 주행 시간 : AVG_match_time = SUM_match_time(match_time 합) / match_time이 있는 유저수
SELECT T2.map_name, T1.SUM_match_time, T1.AVG_match_time
FROM (SELECT track_id
	   ,SUM(match_time) AS SUM_match_time
       ,AVG(match_time) AS AVG_match_time
FROM single_speed_0912_1010_fin
WHERE match_time IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC) AS T1 
LEFT JOIN track_name AS T2 ON T1.track_id = T2.trackId;




# (5)-3 트랙별 리타이어률 : percent_retire = 매치 별 리타이어한 유저 수 / 매치별 플레이한 유저 수 (게임 종료한 유저수) *100

# with문 생성 : 매치별 리타이어한 유저 수, 플레이 한 유저 수, 맵 네임 계산 테이블 지정
with retire_player AS
( # 매치별 리타이어한 유저 수 계산
	SELECT id
		   ,COUNT(user_id) AS cnt_retire_user
	FROM single_speed_0912_1010_fin
	WHERE match_rank=99
	GROUP BY 1), 
all_player AS 
( # 매치별 플레이한 유저 수 계산 (게임 종료 한 유저 제외)
	SELECT id
		   ,COUNT(DISTINCT user_id) AS cnt_user
	FROM single_speed_0912_1010_fin
	WHERE match_rank !=0
	GROUP BY 1),
match_map AS
( # 매치별 맵 네임 
	SELECT T1.id, T2.map_name
	FROM
	(SELECT id, track_id
	FROM single_speed_0912_1010_fin) AS T1
	LEFT JOIN 
	track_name AS T2
	ON T1.track_id = T2.trackId)
SELECT T4.map_name
	   ,SUM(cnt_retire_user) AS cnt_retire_user
       ,SUM(cnt_user) AS cnt_user
       ,(SUM(cnt_retire_user)/SUM(cnt_user))*100 AS percent_retire
FROM 
( # matchId 별 리타이어한 유저 수, 플레이 한 전체 유저 수 계산
SELECT T1.id
	   ,COALESCE(T2.cnt_retire_user,0) AS cnt_retire_user  #cnt_retire_player가 NULL값이면 리타이어된 유저가 없다는 말이어서 0으로 변환준다.
	   ,T1.cnt_user
FROM all_player AS T1 LEFT JOIN retire_player AS T2 ON T1.id = T2.id) AS T3
LEFT JOIN match_map AS T4  
ON T3.id = T4.id
GROUP BY 1;


# 추가 확인 : 메타데이터에 map_name이 없는 7개의 track_id
SELECT distinct T1.track_id
FROM
(SELECT id, track_id
FROM single_speed_0912_1010_fin) AS T1
LEFT JOIN 
track_name AS T2
ON T1.track_id = T2.trackId
where map_name is null;




###### 위에서 구한 주요 지표 하나의 테이블로 합치기 
With track_cnt AS(
		SELECT T2.map_name, T1.cnt_match
		FROM (SELECT track_id, COUNT(DISTINCT id) AS cnt_match
		FROM single_speed_0912_1010_fin
		GROUP BY 1
		ORDER BY 2 DESC) AS T1 
		LEFT JOIN track_name AS T2 ON T1.track_id = T2.trackId), 
match_time_user AS(
		SELECT T2.map_name, T1.SUM_match_time, T1.AVG_match_time
		FROM (SELECT track_id
			   ,SUM(match_time) AS SUM_match_time
			   ,AVG(match_time) AS AVG_match_time
		FROM single_speed_0912_1010_fin
		WHERE match_time IS NOT NULL
		GROUP BY 1
		ORDER BY 2 DESC) AS T1 
		LEFT JOIN track_name AS T2 ON T1.track_id = T2.trackId),
retire_cnt AS(
		SELECT T4.map_name
			   ,SUM(cnt_retire_user) AS cnt_retire_user
			   ,SUM(cnt_user) AS cnt_user
			   ,(SUM(cnt_retire_user)/SUM(cnt_user))*100 AS percent_retire
		FROM 
		( # matchId 별 리타이어한 유저 수, 플레이 한 전체 유저 수 계산
		SELECT T1.id
			   ,COALESCE(T2.cnt_retire_user,0) AS cnt_retire_user  #cnt_retire_player가 NULL값이면 리타이어된 유저가 없다는 말이어서 0으로 변환준다.
			   ,T1.cnt_user
		FROM 
		   (SELECT id
			   ,COUNT(DISTINCT user_id) AS cnt_user
			FROM single_speed_0912_1010_fin
			WHERE match_rank !=0
			GROUP BY 1) AS T1 
        LEFT JOIN 
			(SELECT id
					,COUNT(user_id) AS cnt_retire_user
			 FROM single_speed_0912_1010_fin
			 WHERE match_rank=99
			 GROUP BY 1)AS T2 ON T1.id = T2.id) AS T3
		LEFT JOIN 
			(SELECT T1.id, T2.map_name
			 FROM (SELECT id, track_id
				   FROM single_speed_0912_1010_fin) AS T1
			 LEFT JOIN 
			 track_name AS T2
			 ON T1.track_id = T2.trackId) AS T4  
		ON T3.id = T4.id
		GROUP BY 1)

SELECT T1.map_name
		,T1.cnt_match
		,T3.cnt_user
		,T3.cnt_retire_user
		,T3.percent_retire
		,T2.SUM_match_time
		,T2.AVG_match_time
FROM track_cnt AS T1 LEFT JOIN
match_time_user AS T2 ON T1.map_name = T2.map_name LEFT JOIN
retire_cnt AS T3 ON T1.map_name = T3.map_name
ORDER BY 2 DESC;
