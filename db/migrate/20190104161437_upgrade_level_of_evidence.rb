class UpgradeLevelOfEvidence < ActiveRecord::Migration
  def change
    LevelOfEvidence.destroy_all
  	LevelOfEvidence.create(level: '1a', treatment:'Therapy / Prevention, Aetiology / Harm', medicine: 'SR (with homogeneity*) of RCTs, The level of evidence is 1A')
	LevelOfEvidence.create(level: '1a', treatment:'Prognosis', medicine: 'SR (with homogeneity*) of inception cohort studies; CDR”  validated in different populations, The level of evidence is 1A')
	LevelOfEvidence.create(level: '1a', treatment:'Diagnosis', medicine: 'SR (with homogeneity*) of Level 1 diagnostic studies; CDR”  with 1b studies from different clinical centres, The level of evidence is 1A')
	LevelOfEvidence.create(level: '1a', treatment:'Differential diagnosis / symptom prevalence study', medicine: 'SR (with homogeneity*) of prospective cohort studies, The level of evidence is 1A')
	LevelOfEvidence.create(level: '1a', treatment:'Economic and decision analyses', medicine: 'SR (with homogeneity*) of Level 1 economic studies, The level of evidence is 1A')

	LevelOfEvidence.create(level: '1b', treatment:'Therapy / Prevention, Aetiology / Harm', medicine: 'Individual RCT (with narrow Confidence Interval”¡), The level of evidence is 1B')
	LevelOfEvidence.create(level: '1b', treatment:'Prognosis', medicine: 'Individual inception cohort study with > 80% follow-up; CDR”  validated in a single population, The level of evidence is 1B')
	LevelOfEvidence.create(level: '1b', treatment:'Diagnosis', medicine: 'Validating** cohort study with good” ” ”  reference standards; or CDR”  tested within one clinical centre, The level of evidence is 1B')
	LevelOfEvidence.create(level: '1b', treatment:'Differential diagnosis / symptom prevalence study', medicine: 'Prospective cohort study with good follow-up****, The level of evidence is 1B')
	LevelOfEvidence.create(level: '1b', treatment:'Economic and decision analyses', medicine: 'Analysis based on clinically sensible costs or alternatives; systematic review(s) of the evidence; and including multi-way sensitivity analyses, The level of evidence is 1B')


	LevelOfEvidence.create(level: '1c', treatment:'Therapy / Prevention, Aetiology / Harm', medicine: 'All or none§, The level of evidence is 1C')
	LevelOfEvidence.create(level: '1c', treatment:'Prognosis', medicine: 'All or none case-series, The level of evidence is 1C')
	LevelOfEvidence.create(level: '1c', treatment:'Diagnosis', medicine: 'Absolute SpPins and SnNouts” “, The level of evidence is 1C')
	LevelOfEvidence.create(level: '1c', treatment:'Differential diagnosis / symptom prevalence study', medicine: 'All or none case-series, The level of evidence is 1C')
	LevelOfEvidence.create(level: '1c', treatment:'Economic and decision analyses', medicine: 'Absolute better-value or worse-value analyses ” ” ” “, The level of evidence is 1C')


	LevelOfEvidence.create(level: '2a', treatment:'Therapy / Prevention, Aetiology / Harm', medicine: 'SR (with homogeneity*) of cohort studies, The level of evidence is 2A')
	LevelOfEvidence.create(level: '2a', treatment:'Prognosis', medicine: 'SR (with homogeneity*) of either retrospective cohort studies or untreated control groups in RCTs, The level of evidence is 2A')
	LevelOfEvidence.create(level: '2a', treatment:'Diagnosis', medicine: 'SR (with homogeneity*) of Level >2 diagnostic studies, The level of evidence is 2A')
	LevelOfEvidence.create(level: '2a', treatment:'Differential diagnosis / symptom prevalence study', medicine: 'SR (with homogeneity*) of 2b and better studies, The level of evidence is 2A')
	LevelOfEvidence.create(level: '2a', treatment:'Economic and decision analyses', medicine: 'SR (with homogeneity*) of Level >2 economic studies, The level of evidence is 2A')


	LevelOfEvidence.create(level: '2b', treatment:'Therapy / Prevention, Aetiology / Harm', medicine: 'Individual cohort study (including low quality RCT; e.g., <80% follow-up), The level of evidence is 2B')
	LevelOfEvidence.create(level: '2b', treatment:'Prognosis', medicine: 'Retrospective cohort study or follow-up of untreated control patients in an RCT; Derivation of CDR”  or validated on split-sample§§§ only, The level of evidence is 2B')
	LevelOfEvidence.create(level: '2b', treatment:'Diagnosis', medicine: 'Exploratory** cohort study with good” ” ”  reference standards; CDR”  after derivation, or validated only on split-sample§§§ or databases, The level of evidence is 2B')
	LevelOfEvidence.create(level: '2b', treatment:'Differential diagnosis / symptom prevalence study', medicine: 'Retrospective cohort study, or poor follow-up, The level of evidence is 2B')
	LevelOfEvidence.create(level: '2b', treatment:'Economic and decision analyses', medicine: 'Analysis based on clinically sensible costs or alternatives; limited review(s) of the evidence, or single studies; and including multi-way sensitivity analyses, The level of evidence is 2B')


	LevelOfEvidence.create(level: '2c', treatment:'Therapy / Prevention, Aetiology / Harm', medicine: '“Outcomes” Research; Ecological studies, The level of evidence is 2C')
	LevelOfEvidence.create(level: '2c', treatment:'Prognosis', medicine: '“Outcomes” Research, The level of evidence is 2C')
	LevelOfEvidence.create(level: '2c', treatment:'Diagnosis', medicine: ', The level of evidence is 2C')
	LevelOfEvidence.create(level: '2c', treatment:'Differential diagnosis / symptom prevalence study', medicine: 'Ecological studies, The level of evidence is 2C')
	LevelOfEvidence.create(level: '2c', treatment:'Economic and decision analyses', medicine: 'Audit or outcomes research, The level of evidence is 2C')


	LevelOfEvidence.create(level: '3a', treatment:'Therapy / Prevention, Aetiology / Harm', medicine: 'SR (with homogeneity*) of case-control studies, The level of evidence is 3A')
	LevelOfEvidence.create(level: '3a', treatment:'Prognosis', medicine: ', The level of evidence is 3A')
	LevelOfEvidence.create(level: '3a', treatment:'Diagnosis', medicine: 'SR (with homogeneity*) of 3b and better studies, The level of evidence is 3A')
	LevelOfEvidence.create(level: '3a', treatment:'Differential diagnosis / symptom prevalence study', medicine: 'SR (with homogeneity*) of 3b and better studies, The level of evidence is 3A')
	LevelOfEvidence.create(level: '3a', treatment:'Economic and decision analyses', medicine: 'SR (with homogeneity*) of 3b and better studies, The level of evidence is 3A')


	LevelOfEvidence.create(level: '3b', treatment:'Therapy / Prevention, Aetiology / Harm', medicine: 'Individual Case-Control Study, The level of evidence is 3B')
	LevelOfEvidence.create(level: '3b', treatment:'Prognosis', medicine: ', The level of evidence is 3B')
	LevelOfEvidence.create(level: '3b', treatment:'Diagnosis', medicine: 'Non-consecutive study; or without consistently applied reference standards, The level of evidence is 3B')
	LevelOfEvidence.create(level: '3b', treatment:'Differential diagnosis / symptom prevalence study', medicine: 'Non-consecutive cohort study, or very limited population, The level of evidence is 3B')
	LevelOfEvidence.create(level: '3b', treatment:'Economic and decision analyses', medicine: 'Analysis based on limited alternatives or costs, poor quality estimates of data, but including sensitivity analyses incorporating clinically sensible variations, The level of evidence is 3B')


	LevelOfEvidence.create(level: '4', treatment:'Therapy / Prevention, Aetiology / Harm', medicine: 'Case-series (and poor quality cohort and case-control studies§§), The level of evidence is 4')
	LevelOfEvidence.create(level: '4', treatment:'Prognosis', medicine: 'Case-series (and poor quality cohort and case-control studies§§), The level of evidence is 4')
	LevelOfEvidence.create(level: '4', treatment:'Diagnosis', medicine: 'Case-control study, poor or non-independent reference standard, The level of evidence is 4')
	LevelOfEvidence.create(level: '4', treatment:'Differential diagnosis / symptom prevalence study', medicine: 'Case-series or superseded reference standards, The level of evidence is 4')
	LevelOfEvidence.create(level: '4', treatment:'Economic and decision analyses', medicine: 'Analysis with no sensitivity analysis, The level of evidence is 4')


	LevelOfEvidence.create(level: '5', treatment:'Therapy / Prevention, Aetiology / Harm', medicine: 'Expert opinion without explicit critical appraisal, or based on physiology, bench research or “first principles”, The level of evidence is 5')
	LevelOfEvidence.create(level: '5', treatment:'Prognosis', medicine: 'Expert opinion without explicit critical appraisal, or based on physiology, bench research or “first principles”, The level of evidence is 5')
	LevelOfEvidence.create(level: '5', treatment:'Diagnosis', medicine: 'Expert opinion without explicit critical appraisal, or based on physiology, bench research or “first principles”, The level of evidence is 5')
	LevelOfEvidence.create(level: '5', treatment:'Differential diagnosis / symptom prevalence study', medicine: 'Expert opinion without explicit critical appraisal, or based on physiology, bench research or “first principles”, The level of evidence is 5')
	LevelOfEvidence.create(level: '5', treatment:'Economic and decision analyses', medicine: 'Expert opinion without explicit critical appraisal, or based on economic theory or “first principles”, The level of evidence is 5')
  end
end
