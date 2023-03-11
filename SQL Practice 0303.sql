-- 群組資料清單函數（查詢未群組話前的資料List）每家資料庫的這個語法不一樣 分隔符號變成斜線
-- 欄位別名
-- 1. AS 可省略不寫
-- 2. 別名前後要用雙引號
-- 3. 雙引號可以省略不寫但建議寫出讓排版清楚
-- 4. 別名中間如果要有空白就要用雙引號ALTER

SELECT STORE_NAME,SUM(SALES), COUNT(STORE_ID), 
	GROUP_CONCAT(SALES ORDER BY SALES DESC SEPARATOR '/') AS "List Sales"
FROM STORE_INFORMATION
GROUP BY STORE_NAME;

-- 表格別名
-- AS 可不寫
-- 不可以有雙引號
-- 有表格別名後可以在SELECT那列在表格前面加上別名
SELECT STORE.STORE_ID, STORE.STORE_NAME
FROM STORE_INFORMATION AS STORE;

-- 表格別名若要用JOIN的時候就可以識別
SELECT S.STORE_ID, S.STORE_NAME, S.SALES, S.GEOGRAPHY_ID,G.REGION_NAME
FROM STORE_INFORMATION AS S, GEOGRAPHY AS G
-- 一次查兩張表（跨資料表JOin關聯or查詢）StoreID_6 消失是因為lack GEOGRAPHY_ID
WHERE S.GEOGRAPHY_ID = G.GEOGRAPHY_ID
ORDER BY GEOGRAPHY_ID;

-- 商店有9筆，區域：3筆
-- 沒有JOIN會有 9x3=27筆
SELECT G.*, S.*
FROM GEOGRAPHY, STORE_INFORMATION S;

-- JOIN 這兩個表格 ON 特定欄位
SELECT G.*, S.*
FROM GEOGRAPHY AS G JOIN STORE_INFORMATION AS S
ON  G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;

-- 以兩個圈圈的交集、聯集區分左右等JOIN，因為要 GEOGRAPHY_ID 全部要出現，即使3 North 沒有相符的，所以要 LEFT JOIN(因為G在左)
SELECT G.*, S.*
FROM GEOGRAPHY AS G LEFT JOIN STORE_INFORMATION AS S
ON  G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;

-- 不管商店有無所數區域都要跑出來= STORE 變成主角
SELECT G.*, S.*
FROM GEOGRAPHY AS G RIGHT JOIN STORE_INFORMATION AS S
ON  G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;

-- 如果要全部都出現，MySQL 不支援 FULL JOIN
SELECT G.*, S.*
FROM GEOGRAPHY AS G RIGHT JOIN STORE_INFORMATION AS S
ON  G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;

-- 交叉乘積、交叉連接（CROSS JOIN=JOIN沒+ON）會將兩個交叉相乘的可能排列組合全顯示
SELECT G.*, S.*
FROM GEOGRAPHY AS G CROSS JOIN STORE_INFORMATION AS S;

-- 查詢各區域的營業額總計 個別區域=GROUP BY
-- 資料結果依營業額總計由大到小排序 
-- (不論該區域底下是否有所屬商店) = 區域為主角
SELECT G.REGION_NAME, SUM(S.SALES) AS "SUM_SALES", IFNULL(SUM(S.SALES),0) -- 希望把NULL變成我要的預設值
FROM GEOGRAPHY AS G LEFT JOIN STORE_INFORMATION AS S
ON  G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
GROUP BY G.REGION_NAME
ORDER BY SUM_SALES DESC;

-- 希望把NULL變成我要的預設值且不要多出一欄
SELECT G.REGION_NAME, IFNULL(SUM(S.SALES),0) AS "SUM_SALES" 
FROM GEOGRAPHY AS G LEFT JOIN STORE_INFORMATION AS S
ON  G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
GROUP BY G.REGION_NAME
ORDER BY SUM_SALES DESC;

-- 查詢各區域的商店個數 
-- 資料結果依區域的商店個數由大至小排序 
-- (依據商店名稱,不包含重覆的商店) DISTINCT 
-- (不論該區域底下是否有所屬商店)
SELECT G.REGION_NAME, COUNT(DISTINCT(S.STORE_NAME)) AS "COUNT_STORE"
FROM GEOGRAPHY AS G LEFT JOIN STORE_INFORMATION AS S
ON  G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
GROUP BY G.REGION_NAME
ORDER BY COUNT_STORE DESC;

-- 把兩個欄位串接成一個欄位 CONCAT(字串,字串)
SELECT CONCAT(STORE_ID,'. ',STORE_NAME,', ', SALES) AS "COMBINE STORE INFO"
FROM STORE_INFORMATION;

SELECT STORE_NAME, SUBSTR(STORE_NAME,2),SUBSTR(STORE_NAME,2,4)
FROM STORE_INFORMATION;

-- TRIM 函數是用來移除
-- TRIM([[位置] [要移除的字串] FROM ] 字串):[位置] 的可能值為 LEADING (起頭), TRAILING (結尾), or BOTH (起頭及 結尾)。 
-- 這個函數將把 [要移除的字串] 從字串的起頭、結尾，或是起頭及結尾移除。
SELECT STORE_ID,STORE_NAME,
	TRIM(LEADING 'BOS'FROM STORE_NAME),
	TRIM(TRAILING 'S' FROM STORE_NAME),
    TRIM(BOTH 'L' FROM STORE_NAME)
FROM STORE_INFORMATION;


