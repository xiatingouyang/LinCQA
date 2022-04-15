WITH  sfr AS (SELECT DISTINCT * FROM (SELECT r_1.A61 AS a0, r_0.A51 AS a1, r_0.A52 AS a2, r_0.A53 AS a3 FROM r_5 r_0, r_6 r_1, r_9 r_2 WHERE r_0.A51 = r_2.A91 AND r_0.A52 = r_1.A62 AND r_1.A62 = r_2.A92) t),
      bb_r_5 AS (SELECT DISTINCT * FROM (SELECT s_0.a1 AS a0, s_0.a2 AS a1, s_0.a3 AS a2 FROM sfr s_0 INNER JOIN r_5 r_1 ON s_0.a1 = r_1.A51 WHERE r_1.A52 != s_0.a2 OR r_1.A53 != s_0.a3) t),
      yes_r_5 AS (SELECT DISTINCT * FROM (SELECT s_0.a1 AS a0, s_0.a2 AS a1, s_0.a3 AS a2 FROM sfr s_0, r_5 r_1 WHERE s_0.a1 = r_1.A51 AND s_0.a2 = r_1.A52 AND s_0.a3 = r_1.A53 AND NOT EXISTS (SELECT * FROM bb_r_5 neg_b_0 WHERE neg_b_0.a0 = s_0.a1 AND neg_b_0.a1 = s_0.a2 AND neg_b_0.a2 = s_0.a3)) t),
      bb_r_9 AS (SELECT DISTINCT * FROM (SELECT s_0.a1 AS a0, s_0.a2 AS a1, s_0.a3 AS a2 FROM sfr s_0 INNER JOIN r_9 r_1 ON s_0.a1 = r_1.A91 LEFT OUTER JOIN yes_r_5 y_2 ON s_0.a1 = r_1.A91 AND r_1.A91 = y_2.a0 AND s_0.a2 = y_2.a1 AND s_0.a3 = y_2.a2 WHERE r_1.A91 IS NULL OR y_2.a0 IS NULL OR y_2.a1 IS NULL OR y_2.a2 IS NULL OR r_1.A92 != s_0.a2) t),
      yes_r_9 AS (SELECT DISTINCT * FROM (SELECT s_0.a2 AS a0, s_0.a2 AS a1, s_0.a3 AS a2 FROM sfr s_0, r_9 r_1 WHERE s_0.a1 = r_1.A91 AND s_0.a2 = r_1.A92 AND NOT EXISTS (SELECT * FROM bb_r_9 neg_b_0 WHERE neg_b_0.a0 = s_0.a1 AND neg_b_0.a1 = s_0.a2 AND neg_b_0.a2 = s_0.a3)) t),
      bb_r_6 AS (SELECT DISTINCT * FROM (SELECT s_0.a0 AS a0, s_0.a3 AS a1 FROM sfr s_0 INNER JOIN r_6 r_1 ON s_0.a0 = r_1.A61 LEFT OUTER JOIN yes_r_9 y_2 ON s_0.a3 = y_2.a2 AND r_1.A62 = y_2.a0 AND y_2.a0 = y_2.a1 WHERE y_2.a2 IS NULL OR y_2.a0 IS NULL OR y_2.a1 IS NULL) t) 
     SELECT DISTINCT * FROM (SELECT s_0.a3 AS a0 FROM sfr s_0, r_6 r_1 WHERE s_0.a0 = r_1.A61 AND s_0.a2 = r_1.A62 AND NOT EXISTS (SELECT * FROM bb_r_6 neg_b_0 WHERE neg_b_0.a0 = s_0.a0 AND neg_b_0.a1 = s_0.a3)) t;