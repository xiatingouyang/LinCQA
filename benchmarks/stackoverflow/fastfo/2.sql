WITH sfr AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        b_1.Name AS a0,
        b_1.Date AS a1,
        u_0.DisplayName AS a2,
        u_0.Id AS a3
      FROM
        Users u_0,
        Badges b_1
      WHERE
        u_0.Id = b_1.UserId
	AND b_1.Name = "Illuminator"
    ) t
),
yes_Badges AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a3 AS a0
      FROM
        sfr s_0,
        Badges b_1
      WHERE
        s_0.a0 = b_1.Name
        AND s_0.a1 = b_1.Date
        AND s_0.a3 = b_1.UserId
    ) t
),
bb_Users AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a2 AS a0,
        s_0.a3 AS a1
      FROM
        sfr s_0
        INNER JOIN Users u_1 ON s_0.a3 = u_1.Id
        LEFT OUTER JOIN yes_Badges y_2 ON s_0.a3 = u_1.Id
        AND u_1.Id = y_2.a0
      WHERE
        u_1.Id IS NULL
        OR y_2.a0 IS NULL
        OR u_1.DisplayName != s_0.a2
    ) t
)
SELECT
  DISTINCT *
FROM
  (
    SELECT
      s_0.a3 AS a0,
      s_0.a2 AS a1
    FROM
      sfr s_0,
      Users u_1
    WHERE
      s_0.a2 = u_1.DisplayName
      AND s_0.a3 = u_1.Id
      AND NOT EXISTS (
        SELECT
          *
        FROM
          bb_Users neg_b_0
        WHERE
          neg_b_0.a0 = s_0.a2
          AND neg_b_0.a1 = s_0.a3
      )
  ) t;

