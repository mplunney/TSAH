SELECT 
	main."row.names" AS subj_number
    ,main.zsubjectid
    ,main.age
    ,main.rotterdam
    ,CASE WHEN main.outcome = 0 THEN FALSE
    	WHEN main.outcome = 1 THEN TRUE
	END AS study_outcome_favorable
    ,gose.gose_val
    ,gose.gose_cat
    ,main.treatment AS randomized_tx_group
    ,main.real_trt AS real_tx_group
    ,death.zitemnm AS deathcause
    ,main.igcs_rand
    ,main.intubated_rand
FROM public.derived_elements AS main
LEFT JOIN public.gose_outcome AS gose
	ON main.zsubjectid = gose.zsubjectid


--reference joins
LEFT JOIN public.code_list death
	ON death.zcodegroup = 583
    AND main.deathcause = death.zitemnb
;