-- Q1. 시작 배터리가 20 미만이었던 충전
SELECT robot_name, start_battery, charge_date
FROM charge_log
WHERE start_battery < 20
ORDER BY start_battery;

-- Q2. 충전 시간이 가장 긴 3건
SELECT robot_name, station, minutes
FROM charge_log
ORDER BY minutes DESC
LIMIT 3;

-- Q3. 끝 배터리가 비어 있는 기록
SELECT id, robot_name, end_battery
FROM charge_log
WHERE end_battery IS NULL;

-- Q4. 비어 있는 끝 배터리를 70으로 고치기
UPDATE charge_log
SET end_battery = 70
WHERE end_battery IS NULL
RETURNING id, robot_name, end_battery;

-- Q5. 시험용 robot-9 기록 지우기
DELETE FROM charge_log
WHERE robot_name = 'robot-9'
RETURNING id, robot_name, minutes;

-- Q6. 전체 충전 횟수, 평균 충전 시간, 가장 긴 충전 시간
SELECT COUNT(*) AS charges, ROUND(AVG(minutes), 1) AS avg_min, MAX(minutes) AS max_min
FROM charge_log;

-- Q7. 충전소별 충전 횟수와 평균 충전 시간
SELECT station, COUNT(*) AS charges, ROUND(AVG(minutes), 1) AS avg_min
FROM charge_log
GROUP BY station
ORDER BY station;

-- Q8. 두 번 이상 충전한 로봇의 충전 횟수와 오른 배터리 합
SELECT robot_name, COUNT(*) AS charges, SUM(end_battery - start_battery) AS gained
FROM charge_log
GROUP BY robot_name
HAVING COUNT(*) >= 2
ORDER BY gained DESC;

-- Q9. 로봇별 충전 효율 리포트
SELECT robot_name, COUNT(*) AS charges, SUM(minutes) AS total_min,
       SUM(end_battery - start_battery) AS gained,
       ROUND(SUM(end_battery - start_battery) * 1.0 / SUM(minutes), 2) AS rate
FROM charge_log
GROUP BY robot_name
HAVING COUNT(*) >= 2
ORDER BY rate DESC;

-- Q10. 충전소·날짜별 운영 리포트
SELECT station, charge_date, COUNT(*) AS charges, COUNT(DISTINCT robot_name) AS robots,
       SUM(minutes) AS total_min, ROUND(AVG(start_battery), 1) AS avg_start
FROM charge_log
GROUP BY station, charge_date
HAVING SUM(minutes) >= 95
ORDER BY total_min DESC, station, charge_date;
