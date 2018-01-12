SELECT zsubjectid
	,MIN(GOSE_2,GOSE_3,GOSE_4,GOSE_5,GOSE_6,GOSE_7,GOSE_8) AS gose
FROM
	(
        SELECT --"row.names"
            eos.zsubjectid
            ,CASE WHEN f27q03 = 4 THEN 1 END AS GOSE_1
            ,CASE WHEN f16q01 = 0 
                THEN 2 
            END AS GOSE_2 								/*VS*/
            ,CASE WHEN (f16q02b = 1 AND f16q02c <> 1) 
                THEN 3
            END AS GOSE_3 								/*LOWER SD*/
            ,CASE WHEN (f16q02b = 0 AND f16q02c <> 1) 
                    OR (f16q03A = 0 AND f16q03b <> 0) 
                    OR (f16q04A = 0 AND f16q04b <> 0) 
                THEN 4 
            END AS GOSE_4								/*UPPER SD*/
            ,CASE WHEN (f16q05b = 2 AND f16q05c <> 0) 
                    OR (f16q06b=3 AND f16q06c <> 0) 
                    OR (f16q07b = 3 AND f16q07c <> 1) 
                THEN 5 
            END AS GOSE_5								/*LOWER MD*/
            ,CASE WHEN (f16q05b = 1 AND f16q05c <> 0) 
                    OR (f16q06b = 2 AND f16q06c <> 0) 
                    OR (f16q07b = 2 AND f16q07c <>1) 
                THEN 6 
            END AS GOSE_6								/*UPPER MD*/
            ,CASE WHEN (f16q06b = 1 AND f16Q06c <> 0) 
                    OR (f16q07b = 1 AND f16q07c <> 1) 
                    OR (f16q08a =1 AND f16q08b <> 1)
                THEN 7 
            END AS GOSE_7								/*LOWER GR*/
            ,CASE WHEN (f16q08a =0 AND f16q08b <> 1)
        			OR f16qc IS NOT NULL
                THEN 8 
            END AS GOSE_8				 				/*UPPER GR*/
        FROM public.form27_end_of_study AS eos
        LEFT JOIN public.form16_glasgow_outcome_scale_extended AS gose
            ON eos.zsubjectid = gose.zsubjectid
    ) AS gose
GROUP BY zsubjectid      
;

