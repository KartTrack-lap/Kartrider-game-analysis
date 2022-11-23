--  테이블 명 : api-rawdata-singleplay
--  테이블 설명 : 넥슨 API에서 수집한 카트라이더 개인전 매치, 유저 데이터
--  수집 기간 : 2021-09-12 00:00:00 ~ 2022-10-10 00:00:00

#kart_data 스키마 생성
USE kart_data;

# (1) matchtype확인
# 결과 : 
# 1. {"id":"7b9f0fd5377c38514dbb78ebe63ac6c3b81009d5a31dd569d1cff8f005aa881a","name":"스피드 개인전"}
# 2. {"id":"7ca6fd44026a2c8f5d939b60aa56b4b1714b9cc2355ec5e317154d4cf0675da0","name":"아이템 개인전"}
# 3. {"id":"ee2426e23fa56f7a695084e1fc07fe6bb03a0b3b0c71c4e1f1b7e7e78e6c6878","name":"아이템 팀 배틀모드"}
# 4. Null
SELECT DISTINCT match_type_id
FROM `match`;

# (1)-1 스피드 개인전 매치 건수 : 98,194건
SELECT COUNT(DISTINCT id)
FROM `match`
WHERE match_type_id ='7b9f0fd5377c38514dbb78ebe63ac6c3b81009d5a31dd569d1cff8f005aa881a';

# (1)-2 아이템 개인전 매치 건수 : 48,804건
SELECT COUNT(DISTINCT id)
FROM `match`
WHERE match_type_id ='7ca6fd44026a2c8f5d939b60aa56b4b1714b9cc2355ec5e317154d4cf0675da0';

# (1)-3 아이템 팀 배틀모드매치 건수 : 8,223건
SELECT COUNT(DISTINCT id)
FROM `match`
WHERE match_type_id ='ee2426e23fa56f7a695084e1fc07fe6bb03a0b3b0c71c4e1f1b7e7e78e6c6878';

# (1)-4 NULL : 5,965건
SELECT COUNT(DISTINCT id)
FROM `match`
WHERE match_type_id IS NULL;

-- 어떤 모드인지 특정할 수 없기 때문에 고려하지 않기로 결정
SELECT *
FROM `match`
WHERE match_type_id IS NULL
LIMIT 100;


# 2. 스피드 개인전 테이블 생성 
CREATE TABLE single_speed_0912_1010
SELECT *
FROM `match`
WHERE match_type_id ='7b9f0fd5377c38514dbb78ebe63ac6c3b81009d5a31dd569d1cff8f005aa881a';

# (1) 주요 데이터 확인
# 매치 건 수 :  98,194건
# 유저 수 : 65,913명
# 매치에서 사용 된 트랙 수 : 326개

# 매치 건 수 :  98,194건
SELECT COUNT(DISTINCT id)
FROM single_speed_0912_1010;

# 유저 수 : 65,913명
SELECT COUNT(DISTINCT player_id)
FROM single_speed_0912_1010;


# 매치에서 사용 된 트랙 수 : 326개
SELECT COUNT(DISTINCT track_id)
FROM single_speed_0912_1010;



-- ---------------------------------------------------
# (2) player_id에 음수 값이 없다. 
SELECT DISTINCT player_id
FROM single_speed_0912_1010
ORDER BY 1 ASC;


-- ---------------------------------------------------

# (3) rank는 해당 매치에서의 순위로 1~8이 있고, 리타이어시 99, 게임 종료 시 0 이다.
#(3).1 해당 매치에서의 순위, 리타이어시 99, 게임 종료시“”
# 검증결과 -> 0,99,1~8까지 있다.
SELECT DISTINCT `rank`
FROM single_speed_0912_1010
ORDER BY 1;

#(3)-2 99가 리타이어라면, retired가 1일 것이다.
# 검증 : 검증 완료, 99인 경우만 matchRetired가 1이다.
SELECT DISTINCT retired
FROM single_speed_0912_1010
WHERE `rank`=99;

SELECT DISTINCT retired
FROM single_speed_0912_1010
WHERE `rank`!=99;


#(3)-3 0이 게임 종료라면, record과 result은 null이고 retired은 0이다.
# 검증 :확인 완료, 0은 게임 종료다
SELECT DISTINCT record
FROM single_speed_0912_1010
WHERE `rank`=0;

SELECT DISTINCT retired
FROM single_speed_0912_1010
WHERE `rank`=0;

SELECT DISTINCT result
FROM single_speed_0912_1010
WHERE `rank`=0;


-- ---------------------------------------------------

# (4). retired가 1이면(리타이어 시), record이 NULL이다.
# 검증 결과 : 검증완료
SELECT DISTINCT record
FROM single_speed_0912_1010
WHERE retired=1;


-- ---------------------------------------------------

# (5). 리타이어된 사람과 중간에 이탈한 사람으로 구성된 match를 제거해 줄지 결정 필요

#(5)-1. result은 승리는 1, 패배는 0, 게임 종료시 ""
#검증 결과 : 검증 완료
SELECT DISTINCT result
FROM single_speed_0912_1010;

#(5)-2. 개인전이기 때문에, result가 1(승리)이면, rank는 1일 것이다.
#검증 결과 : rank에 1,99값이 있다. -> rank가 99인데 result가 1인 경우 53건이고 나머지 65,528건은 0이다. 
SELECT DISTINCT `rank`
FROM single_speed_0912_1010
WHERE result=1;

# rank가 99인데 result이 1인 경우 212건이고 나머지는 0이다. 
SELECT result, count(result)
FROM single_speed_0912_1010
WHERE `rank` = 99
GROUP BY 1;

SELECT *
FROM single_speed_0912_1010
WHERE `rank` = 99
ORDER BY result DESC;

# 위의 경우는 리타이어된 사람과 중간에 이탈한 사람으로 구성된 match이다. 
SELECT *
FROM single_speed_0912_1010
WHERE id = '0051000b8c7501a7' ;


-- ---------------------------------------------------

# (2) 분석에 필요한 테이블 생성
# 조건 : 매치의 모든 플레이어의 rank가 0 혹은 99인 매치는 완주하지 않은 매치로 간주하고 제외

CREATE TABLE single_speed_0912_1010_fin
SELECT *
FROM
(SELECT id
FROM single_speed_0912_1010
WHERE `rank` = 1 ) AS T1 #완주 한 매치는 `rank`에 1이 존재한다. 
LEFT JOIN 
(SELECT * 
FROM single_speed_0912_1010) AS T2 #rank에 1이 존재하는 id를 기준으로 LeftJoin해주면, 모든 유저가 완주하지 않는 매치는 포함되지 않는다. 
ON T1.id = T2.id
WHERE T1.id NOT IN ('00ed000b3df1ab9a','031d000b6dc5b78d','031d000b6dc5b78d'); #start와 end가 match_start_time이 아닌 3건을 제외해준다.



# (3) 생성한 테이블을 검증한다. 

#(3)-1 개인전이기 때문에, matchWin이 1(승리)이면, matchRank는 1일 것이다.
#검증 결과 : 검증 완료
SELECT DISTINCT `rank`
FROM single_speed_0912_1010_fin
WHERE result = 1;

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
SELECT T1.track_id, T1.cnt_match
FROM (SELECT track_id, COUNT(DISTINCT id) AS cnt_match
FROM single_speed_0912_1010_fin
GROUP BY 1
ORDER BY 2 DESC) AS T1;

-- SELECT T2.map_name, T1.cnt_match
-- FROM (SELECT track_id, COUNT(DISTINCT id) AS cnt_match
-- FROM single_speed_0912_1010_fin
-- GROUP BY 1
-- ORDER BY 2 DESC) AS T1 
-- LEFT JOIN track_name AS T2 ON T1.track_id = T2.trackId;


# (5)-2 트랙별 주행 시간 : AVG_match_time = SUM_match_time(match_time 합) / match_time이 있는 유저수
SELECT T1.track_id, T1.SUM_record, T1.AVG_record
FROM (SELECT track_id
	   ,SUM(record) AS SUM_record
       ,AVG(record) AS AVG_record
FROM single_speed_0912_1010_fin
WHERE record IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC) AS T1 ;





# (5)-3 트랙별 리타이어률 : percent_retire = 매치 별 리타이어한 유저 수 / 매치별 플레이한 유저 수 (게임 종료한 유저수) *100

# with문 생성 : 매치별 리타이어한 유저 수, 플레이 한 유저 수, 맵 네임 계산 테이블 지정
with retire_player AS
( # 매치별 리타이어한 유저 수 계산
	SELECT id
		   ,COUNT(user_id) AS cnt_retire_user
	FROM single_speed_0912_1010_fin
	WHERE `rank`=99
	GROUP BY 1), 
all_player AS 
( # 매치별 플레이한 유저 수 계산 (게임 종료 한 유저 제외)
	SELECT id
		   ,COUNT(DISTINCT user_id) AS cnt_user
	FROM single_speed_0912_1010_fin
	WHERE `rank` !=0
	GROUP BY 1),
match_map_id AS
( # 매치별 맵 id
	SELECT id, track_id
	FROM single_speed_0912_1010_fin)
SELECT T4.track_id
	   ,SUM(cnt_retire_user) AS cnt_retire_user
       ,SUM(cnt_user) AS cnt_user
       ,(SUM(cnt_retire_user)/SUM(cnt_user))*100 AS percent_retire
FROM 
( # matchId 별 리타이어한 유저 수, 플레이 한 전체 유저 수 계산
SELECT T1.id
	   ,COALESCE(T2.cnt_retire_user,0) AS cnt_retire_user  #cnt_retire_player가 NULL값이면 리타이어된 유저가 없다는 말이어서 0으로 변환준다.
	   ,T1.cnt_user
FROM all_player AS T1 LEFT JOIN retire_player AS T2 ON T1.id = T2.id) AS T3
LEFT JOIN match_map_id AS T4 ON T3.id = T4.id
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
		SELECT T1.track_id, T1.cnt_match
		FROM (SELECT track_id, COUNT(DISTINCT id) AS cnt_match
		FROM single_speed_0912_1010_fin
		GROUP BY 1
		ORDER BY 2 DESC) AS T1), 
match_time_user AS(
		SELECT T1.track_id, T1.SUM_record, T1.AVG_record
		FROM (SELECT track_id
			   ,SUM(record) AS SUM_record
			   ,AVG(record) AS AVG_record
		FROM single_speed_0912_1010_fin
		WHERE record IS NOT NULL
		GROUP BY 1
		ORDER BY 2 DESC) AS T1),
retire_cnt AS(
		SELECT T4.track_id
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
			   ,COUNT(user_id) AS cnt_user
			FROM single_speed_0912_1010_fin
			WHERE `rank` !=0
			GROUP BY 1) AS T1 
        LEFT JOIN 
			(SELECT id
					,COUNT(user_id) AS cnt_retire_user
			 FROM single_speed_0912_1010_fin
			 WHERE `rank`=99
			 GROUP BY 1)AS T2 ON T1.id = T2.id) AS T3
		LEFT JOIN 
			(SELECT id, track_id
			 FROM single_speed_0912_1010_fin) AS T4  
		ON T3.id = T4.id
		GROUP BY 1)

SELECT T4.map_name
		,T1.track_id
		,T1.cnt_match
		,T3.percent_retire
		,T2.AVG_record
FROM track_cnt AS T1 LEFT JOIN
match_time_user AS T2 ON T1.track_id = T2.track_id LEFT JOIN
retire_cnt AS T3 ON T1.track_id = T3.track_id LEFT JOIN
track_name AS T4 ON T1.track_id = T4.trackId
ORDER BY 2 DESC;
