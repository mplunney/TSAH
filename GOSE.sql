/*Postgres query to define GOSE primary outcome
	M.Lunney 2018-01-15
*/

--create outcome table with SubjectID, raw GOSE score, and categorical outcome
CREATE TABLE public.gose_outcome
    (
        zsubjectid integer NOT NULL,
        gose_val integer,
        gose_cat text COLLATE pg_catalog."default",
        CONSTRAINT gose_outcome_pkey PRIMARY KEY (zsubjectid)
    )
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.gose_outcome
    OWNER to postgres;

--populate table from raw data recorded in form16_glasgow_outcome_scale_extended
INSERT INTO public.gose_outcome(
	zsubjectid, gose_val, gose_cat)
    
SELECT zsubjectid
    ,gose AS gose_val
    ,CASE WHEN gose = 1 THEN 'Dead'
        WHEN gose = 2 THEN 'Vegetative state'
        WHEN gose = 3 THEN 'Lower severe disability'
        WHEN gose = 4 THEN 'Upper severe disability'
        WHEN gose = 5 THEN 'Lower moderate disability'
        WHEN gose = 6 THEN 'Upper moderate disability'
        WHEN gose = 7 THEN 'Lower good recovery'
        WHEN gose = 8 THEN 'Upper good recovery'
        WHEN gose IS NULL THEN 'GOSE not obtained'
    END AS gose_cat
FROM
    (
        SELECT 
            eos.zsubjectid
            ,CASE WHEN f27q03 = 4 THEN 1						/*Dead*/
                WHEN f16q01 = 0 THEN 2							/*VS*/
                WHEN (f16q02b = 1 AND f16q02c <> 1) THEN 3		/*LOWER SD*/
                WHEN (f16q02b = 0 AND f16q02c <> 1) 
                    OR (f16q03A = 0 AND f16q03b <> 0) 
                    OR (f16q04A = 0 AND f16q04b <> 0) THEN 4 	/*UPPER SD*/
                WHEN (f16q05b = 2 AND f16q05c <> 0) 
                    OR (f16q06b=3 AND f16q06c <> 0) 
                    OR (f16q07b = 3 AND f16q07c <> 1) THEN 5 	/*LOWER MD*/
                WHEN (f16q05b = 1 AND f16q05c <> 0) 
                    OR (f16q06b = 2 AND f16q06c <> 0) 
                    OR (f16q07b = 2 AND f16q07c <>1) THEN 6 	/*UPPER MD*/
                WHEN (f16q06b = 1 AND f16Q06c <> 0) 
                    OR (f16q07b = 1 AND f16q07c <> 1) 
                    OR (f16q08a =1 AND f16q08b <> 1) THEN 7 	/*LOWER GR*/
                WHEN (f16q08a =0 AND f16q08b <> 1)
                    OR f16qc IS NOT NULL THEN 8 				/*UPPER GR*/
            END AS gose
        FROM public.form27_end_of_study AS eos
        LEFT JOIN public.form16_glasgow_outcome_scale_extended AS gose
            ON eos.zsubjectid = gose.zsubjectid
    ) AS gose          
;