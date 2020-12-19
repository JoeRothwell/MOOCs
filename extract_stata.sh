# Process text output from stata: total of 16 digestive cancers
# This output copied into cancer_diabetes_metS_results

# Get number of failures per cancer
egrep "ent:|failures in" LOG_digestive_cancers_27mods.txt > failures_16cancers.txt

# Extract all HRs and CIs from text output and write to file or get number of lines
egrep "event|Idiabet_1|_Ipre_diabe_1|harm_1|_NCEP_1|metS_IDF2_1|obes_1|hdl_1|health_1|health_2|health_3|tryg_1|bp_1|hb_1" LOG_digestive_cancers_27mods.txt > digestive_cancers_metS.txt
egrep "event|Idiabet_1|_Ipre_diabe_1|harm_1|_NCEP_1|metS_IDF2_1|obes_1|hdl_1|health_1|health_2|health_3|tryg_1|bp_1|hb_1" LOG_digestive_cancers_27mods.txt | wc -l
# 512
# shortened with metacharacters
egrep "ent:|diabet?_1|arm_1|CEP_1|IDF2_1|obes_1|hdl_1|hb_1|bp_1|tryg_1|alth_[123]" LOG_digestive_cancers_27mods.txt | wc -l

# Extra corrected file
egrep "event|Idiabet_1|health_1|health_2|health_3" LOG_digestive_cancers_corrections.txt | wc -l
egrep "event|Idiabet_1|health_1|health_2|health_3" LOG_digestive_cancers_corrections.txt > digestive_cancers_metS_extra.txt
egrep "event|alth_[123]" LOG_digestive_cancers_corrections.txt


# After meeting with NM decided just to include colorectal, colon, rectal, oesophageal squamous,
# oesophageal adenocarcinoma, pancreas, stomach cardia, stomach noncardia, hcc, bile duct and 
# all digestive

# Models run again 25-04-2020 to remove family history. First check length
egrep "ent:|diabet?_1|arm_1|CEP_1|IDF2_1|obes_1|hdl_1|hb_1|bp_1|tryg_1|alth_[123]" LOG_digestive_cancers_25042020.txt | wc -l
egrep "ent:|diabet?_1|arm_1|CEP_1|IDF2_1|obes_1|hdl_1|hb_1|bp_1|tryg_1|alth_[123]" LOG_digestive_cancers_25042020.txt > digestive_cancers_metS_new.txt

# All models run again 26-04-2020 to correct mistake in HDL calculation
egrep "ent:|diabet?_1|arm_1|CEP_1|IDF2_1|obes_1|hdl_1|hb_1|bp_1|tryg_1|alth_[123]" LOG_digestive_cancers_26042020.txt | wc -l
egrep "ent:|diabet?_1|arm_1|CEP_1|IDF2_1|obes_1|hdl_1|hb_1|bp_1|tryg_1|alth_[123]" LOG_digestive_cancers_26042020.txt > digestive_cancers_metS_new1.txt

# Pre-diabetes run again 03-05-2020 to correct mistake (included prevalent diabetes)
egrep "ent:|diabet?_1" LOG_digestive_cancers_0305_pre_diabetes.txt | wc -l
egrep "ent:|diabet?_1" LOG_digestive_cancers_0305_pre_diabetes.txt > digestive_cancers_pre_diabetes.txt

# Pre-diabetes run again 03-05-2020 to correct mistake (included prevalent diabetes)
egrep "ent:|Iglc_q4" LOG_digestive_cancers_0405_fast_glc.txt | wc -l
egrep "ent:|Iglc_q4" LOG_digestive_cancers_0405_fast_glc.txt > digestive_cancers_fast_glc.txt
