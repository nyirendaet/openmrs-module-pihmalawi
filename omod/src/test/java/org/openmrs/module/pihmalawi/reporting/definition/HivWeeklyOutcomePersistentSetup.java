package org.openmrs.module.pihmalawi.reporting.definition;

import org.junit.Before;
import org.junit.Ignore;
import org.junit.Test;
import org.openmrs.module.pihmalawi.reports.ReportHelper;
import org.openmrs.module.pihmalawi.reports.setup.outdated.SetupHivWeeklyOutcome;
import org.openmrs.test.BaseModuleContextSensitiveTest;
import org.springframework.test.annotation.Rollback;

@Ignore
public class HivWeeklyOutcomePersistentSetup extends BaseModuleContextSensitiveTest {
	
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
	public void setupHivWeekly() throws Exception {
			new SetupHivWeeklyOutcome(new ReportHelper()).setup(false);
	}
	
}
