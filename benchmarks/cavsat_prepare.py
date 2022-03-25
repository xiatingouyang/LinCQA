def constraint_table_sql():

	sql = """--Drop existing CAvSAT_SYS_CONSTRAINTS table
	DROP TABLE IF EXISTS CAvSAT_SYS_CONSTRAINTS;

	-- Create table CAvSAT_SYS_CONSTRAINTS
	CREATE TABLE [dbo].[CAvSAT_SYS_CONSTRAINTS](
		[Constraint_ID] [int] IDENTITY(1,1) NOT NULL,
		[Constraint_Type] [varchar](255) NOT NULL,
		[Constraint_Definition] [varchar](255) NOT NULL,
	PRIMARY KEY CLUSTERED 
	([Constraint_ID] ASC)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
	UNIQUE NONCLUSTERED 
	([Constraint_Definition] ASC)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]
	"""

	return sql



def get_cavsat_prepare_sqls(table_name, primary_keys_list):

	primary_keys_string = ", ".join(primary_keys_list)


	where_clause_list = []
	for pk in primary_keys_list:
		where_clause_list.append("CONS_KEYS.{} = {}.{}".format(pk, table_name, pk))

	where_clause = " and ".join(where_clause_list)

	create_cons_sql = """
	WITH CONS_KEYS AS (SELECT {} FROM {} GROUP BY {} HAVING COUNT(*) = 1) 
	SELECT * INTO CAVSAT_CONS_{} FROM (SELECT * FROM {} WHERE exists (
		select * from CONS_KEYS 
		where {}) ) A;
	""".format(primary_keys_string, table_name, primary_keys_string,
		table_name, table_name, where_clause)


	create_incons_sql = """
	WITH CONS_KEYS AS (SELECT {} FROM {} GROUP BY {} HAVING COUNT(*) > 1) 
	SELECT * INTO CAVSAT_INCONS_{} FROM (SELECT * FROM {} WHERE exists (
		select * from CONS_KEYS 
		where {}) ) A;
	""".format(primary_keys_string, table_name, primary_keys_string,
		table_name, table_name, where_clause)


	cavsat_prepare_sqls = [
	"""
	-- Drop existing CONS-tables
	DROP TABLE IF EXISTS CAVSAT_CONS_{};
	""".format(table_name), 

	create_cons_sql, 

	"""
	-- Drop existing INCONS-tables
	DROP TABLE IF EXISTS CAVSAT_INCONS_{};
	""".format(table_name),

	create_incons_sql,

	"""
	--Add primary keys to CONS-tables
	ALTER TABLE CAVSAT_CONS_{} ADD PRIMARY KEY ({});
	""".format(table_name, primary_keys_string),

	"""
	-- Drop existing indexes on the INCONS-tables
	DROP INDEX IF EXISTS CAVSAT_INCONS_{}.INCONS_{}_INDEX;
	""".format(table_name, table_name),

	"""
	-- Create indexes on the INCONS-tables
	CREATE CLUSTERED INDEX INCONS_{}_INDEX ON CAVSAT_INCONS_{} ({});
	""".format(table_name, table_name, primary_keys_string),

	"""
	-- Drop existing indexes on the main tables
	DROP INDEX IF EXISTS {}.{}_INDEX;
	""".format(table_name, table_name),

	"""
	-- Create indexes on the main tables
	CREATE CLUSTERED INDEX {}_INDEX ON {} ({});
	""".format(table_name, table_name, primary_keys_string),

	"""
	--Insert key constraints into CAvSAT_SYS_CONSTRAINTS table
	INSERT INTO CAVSAT_SYS_CONSTRAINTS VALUES ('Primary Key', '{}({})')
	""".format(table_name, primary_keys_string)
	]

	return cavsat_prepare_sqls

