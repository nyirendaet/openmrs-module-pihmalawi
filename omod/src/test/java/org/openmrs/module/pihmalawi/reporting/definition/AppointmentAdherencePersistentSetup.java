package org.openmrs.module.pihmalawi.reporting.definition;

import java.util.Arrays;

import org.junit.Before;
import org.junit.Ignore;
import org.junit.Test;
import org.openmrs.api.context.Context;
import org.openmrs.module.pihmalawi.reports.ReportHelper;
import org.openmrs.module.pihmalawi.reports.experimental.historicAppointmentAdherence.SetupAppointmentAdherence;
import org.openmrs.test.BaseModuleContextSensitiveTest;
import org.springframework.test.annotation.Rollback;

@Ignore
public class AppointmentAdherencePersistentSetup extends
		BaseModuleContextSensitiveTest {

	@Override
	public Boolean useInMemoryDatabase() {
		return false;
	}

	@Before
	public void setup() throws Exception {
		authenticate();
	}

	@Test
	@Rollback(false)
	public void setupReport() throws Exception {
		new SetupAppointmentAdherence(new ReportHelper(), "adcc", "Chronic Care", null, Arrays.asList(Context
				.getEncounterService().getEncounterType("CHRONIC_CARE_FOLLOWUP")), false)
				.setup();
//		new SetupAppointmentAdherence(new ReportHelper(), "adart", "ART", Context
//				.getProgramWorkflowService().getProgramByName("HIV program")
//				.getWorkflowByName("Treatment status")
//				.getStateByName("On antiretrovirals"), Arrays.asList(Context
//				.getEncounterService().getEncounterType("ART_INITIAL"), Context
//				.getEncounterService().getEncounterType("ART_FOLLOWUP")), true)
//				.setup();

	}
}
