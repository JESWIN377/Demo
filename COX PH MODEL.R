# The event time T is CVD-free time:
# Time (in years) from baseline examination until:
#   - First diagnosis of CVD
#   - OR confirmed CVD death
# CVD includes coronary heart disease (CHD) and stroke.

# CENS = censoring indicator
# 0 = censored (no CVD during follow-up or non-CVD death)
# 1 = event occurred (CVD)

# DG = Type of CVD outcome
# 0 = No CVD (censored)
# 1 = Stroke
# 2 = Coronary Heart Disease (CHD)
# 3 = Other CVD

# AGE = Continuous age (years)

# Age group comparison (3 groups: 50–59, 60–69, 70–79)
# Dummy coding:
# AGEA = 1 if age 50–69, 0 otherwise
# AGEB = 1 if age 60–69, 0 otherwise
# (Thus 70–79 is reference group: AGEA=0 and AGEB=0)

# SEX = Gender
# 1 = Male
# 0 = Female

# SMOKE = Smoking status
# 1 = Current smoker
# 0 = Non-smoker

# BMI = Body Mass Index
# Weight (kg) / Height (m)^2

# SBP = Systolic Blood Pressure (mmHg)

# LACR = Logarithm of urinary albumin/creatinine ratio

# LTG = Logarithm of triglycerides

# HTN = Hypertension status
# 1 = SBP ≥ 140 mmHg OR DBP ≥ 90 mmHg OR on treatment
# 0 = Otherwise

# DM = Diabetes status
# 1 = Fasting glucose ≥ 126 mg/dL OR on treatment
# 0 = Otherwise
# Create dataframe

cvd <- data.frame(
  ID = 1:68,
  T = c(7.4,7.9,6.4,7.1,6.0,6.5,8.3,7.9,7.6,8.4,7.4,7.7,6.9,7.2,6.3,7.4,4.5,7.0,2.8,7.2,
        7.4,5.2,7.7,7.8,7.6,7.9,7.3,8.2,3.8,6.9,6.1,7.2,8.4,5.0,6.5,6.4,
        2.6,2.7,2.7,3.3,2.9,0.2,2.1,6.8,5.7,1.1,6.6,1.3,4.6,6.3,2.0,4.2,
        3.6,3.2,4.5,4.5,6.1,3.0,2.1,1.3,4.9,2.5,3.8,5.0,1.5,4.1,0.5,2.7),
  
  CENS = c(rep(0,36), rep(1,32)),
  
  DG = c(rep(0,36),
         rep(1,8),
         rep(2,15),
         rep(3,9)),
  
  AGEA = c(rep(0,20), rep(1,16), rep(0,12), rep(1,20)),
  AGEB = c(rep(0,8), rep(1,12), rep(0,16), rep(1,8), rep(0,24)),
  
  SEX = c(0,0,0,0,0,0,1,1,0,0,0,0,1,1,1,1,1,1,1,1,
          0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,
          0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,
          0,0,1,1,0,0,1,1,0,0,1,1,1,0,1,1),
  
  SMOKE = c(0,0,1,1,1,1,0,0,0,0,0,0,1,1,1,1,0,0,0,0,
            0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,
            0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,
            0,1,0,1,0,1,0,1,0,1,0,0,1,0,0,1),
  
  BMI = c(31.78,25.02,26.05,26.92,34.30,31.76,25.01,28.21,28.13,25.68,
          34.34,28.92,24.68,21.93,29.47,28.65,32.28,29.21,28.82,30.58,
          27.83,26.61,30.32,30.41,29.98,26.00,29.05,27.21,36.97,29.44,
          33.85,32.13,27.52,30.64,29.94,29.89,
          30.88,25.05,26.80,21.67,36.83,21.49,31.05,26.78,35.78,28.44,
          24.38,34.13,43.23,38.67,34.49,20.78,
          28.40,28.73,44.25,32.46,39.72,27.90,27.77,31.03,25.22,45.29,
          25.03,46.76,28.53,23.63,31.39,30.29),
  
  SBP = c(141,124,111,140,146,142,154,136,127,118,
          118,127,100,121,98,150,128,117,136,121,
          95,128,96,130,140,118,110,131,141,115,
          154,122,135,114,120,115,
          189,200,130,111,114,125,131,134,132,134,
          124,126,128,126,130,127,
          118,154,97,141,118,117,119,151,129,130,
          188,96,126,144,134,115),
  
  LACR = c(4.23,4.31,4.38,1.11,1.19,1.20,3.53,3.73,2.92,2.47,
           2.37,3.58,2.11,3.39,1.96,2.59,2.99,2.17,4.04,2.84,
           1.85,2.87,2.41,1.45,1.88,2.34,1.44,2.50,4.60,2.89,
           3.48,2.92,2.39,1.39,2.96,1.68,
           5.38,3.37,2.31,3.53,2.64,4.61,1.38,4.36,9.93,3.54,
           4.16,5.87,5.08,5.16,2.69,4.40,
           5.43,1.94,2.01,0.74,2.39,7.45,7.03,3.94,6.69,2.46,
           6.25,3.93,3.09,8.24,6.96,4.70),
  
  LTG = c(3.94,4.66,4.27,4.51,4.82,4.88,4.10,4.12,4.24,4.41,
          4.46,4.55,4.33,4.64,4.69,4.95,4.73,4.91,4.92,4.94,
          4.44,4.51,4.60,4.73,4.51,4.53,4.67,4.68,4.25,4.26,
          4.48,4.48,4.42,4.45,4.49,4.52,
          4.72,4.86,5.10,4.18,4.52,4.69,4.48,4.90,5.11,4.32,
          4.00,3.95,5.25,4.50,3.95,4.54,
          4.66,5.24,4.40,4.39,3.93,5.61,4.71,4.43,3.90,4.40,
          5.63,4.12,4.65,4.82,4.11,4.98),
  
  AGE = c(77.8,76.9,76.3,72.2,76.0,74.5,70.7,75.2,64.9,60.2,
          64.4,68.8,64.4,60.8,64.4,61.6,65.3,65.7,65.4,64.5,
          52.0,50.7,52.5,55.9,53.4,51.0,50.6,57.7,58.7,53.6,
          51.2,55.2,53.7,54.9,50.7,51.3,
          73.9,77.2,73.5,71.1,68.2,67.3,69.1,61.0,52.5,55.7,
          51.8,53.1,72.2,76.8,76.7,73.1,
          69.3,68.9,68.6,63.5,52.6,56.0,54.3,59.2,75.4,75.7,
          71.7,65.6,68.6,59.4,54.2,59.1),
  
  HTN = c(1,0,0,1,1,1,1,1,0,0,0,1,0,0,0,1,0,0,0,0,
          0,0,0,0,1,0,0,0,1,0,1,0,0,1,0,0,
          1,1,0,0,0,0,0,1,0,0,0,0,0,1,1,0,
          1,1,0,1,0,0,0,1,1,1,1,0,1,1,1,1),
  
  DM = c(0,1,0,0,0,0,1,0,0,0,1,1,0,1,0,0,0,1,1,1,
         0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,
         1,1,0,0,0,0,0,0,1,0,1,1,1,1,1,0,
         1,1,1,0,1,1,1,1,0,1,1,0,1,1,0,1)
)
library(survival)

# Survival object
surv_obj <- Surv(time = cvd$T, event = cvd$CENS)

# Cox model (Breslow)
cox_breslow <- coxph(surv_obj ~ AGEA + AGEB + SEX + SMOKE + BMI + LACR,
                     data = cvd, ties = "breslow")

# Cox model (Efron)
cox_efron <- coxph(surv_obj ~ AGEA + AGEB + SEX + SMOKE + BMI + LACR,
                   data = cvd, ties = "efron")

# Cox model (Exact)
cox_exact <- coxph(surv_obj ~ AGEA + AGEB + SEX + SMOKE + BMI + LACR,
                   data = cvd, ties = "exact")

summary(cox_efron)

exp_model <- survreg(surv_obj ~ AGEA + AGEB + SEX + SMOKE + BMI + LACR,
                     data = cvd,
                     dist = "exponential")

summary(exp_model)

weib_model <- survreg(surv_obj ~ AGEA + AGEB + SEX + SMOKE + BMI + LACR,
                      data = cvd,
                      dist = "weibull")

summary(weib_model)

AIC(cox_efron)
AIC(exp_model)
AIC(weib_model)

