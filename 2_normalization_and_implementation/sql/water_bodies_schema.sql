CREATE TABLE IF NOT EXISTS running_water (
	water_id SERIAL PRIMARY KEY,
	water_name VARCHAR(255),
	flow_rate DECIMAL(10, 2),
	water_length DECIMAL(10, 2),
	flows_into INTEGER,
	mileagePoint INTEGER,
	CONSTRAINT fk_running_water_running_water
		FOREIGN KEY (flows_into) REFERENCES running_water(water_id)
			ON DELETE RESTRICT
			ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS standing_water (
	water_id SERIAL PRIMARY KEY,
	water_name VARCHAR(255),
	surface DECIMAL(10,2)
);


CREATE TABLE IF NOT EXISTS organization (
	org_id SERIAL PRIMARY KEY,
	org_name VARCHAR(255)
);


CREATE TABLE IF NOT EXISTS project (
	project_id SERIAL PRIMARY KEY,
	project_title VARCHAR(255),
	total_cost INTEGER,
	start_date DATE,
	end_date DATE
);


CREATE TABLE IF NOT EXISTS researcher (
	email VARCHAR(255) PRIMARY KEY,
	r_name VARCHAR(255),
	provides INTEGER,
	CONSTRAINT fk_researcher_organization
		FOREIGN KEY (provides) REFERENCES organization(org_id)
			ON DELETE RESTRICT
			ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS organization_project_finances (
	org_id INTEGER,
	project_id INTEGER,
	CONSTRAINT fk_organization_project_finances_organization
		FOREIGN KEY (org_id) REFERENCES organization(org_id)
			ON DELETE RESTRICT
			ON UPDATE CASCADE,
	CONSTRAINT fk_organization_project_finances_project
		FOREIGN KEY (project_id) REFERENCES project(project_id)
			ON DELETE RESTRICT
			ON UPDATE CASCADE,
	CONSTRAINT pk_organization_project_finances
		PRIMARY KEY (org_id, project_id)
);


CREATE TABLE IF NOT EXISTS researcher_project_works (
	email VARCHAR(255),
	project_id INTEGER,
	researcher_function VARCHAR(255),
	CONSTRAINT fk_researcher_project_works_researcher
		FOREIGN KEY (email) REFERENCES researcher(email)
			ON DELETE RESTRICT
			ON UPDATE CASCADE,
	CONSTRAINT fk_researcher_project_works_project
		FOREIGN KEY (project_id) REFERENCES project(project_id)
			ON DELETE RESTRICT
			ON UPDATE CASCADE,
	CONSTRAINT pk_researcher_project_works
		PRIMARY KEY (email, project_id)
);


-- As we use horizontal partitioning, i have to separate identical relations :(
CREATE TABLE IF NOT EXISTS standing_water_project_researches (
	water_id INTEGER,
	project_id INTEGER,
	CONSTRAINT fk_standing_water_project_researches_standing_water
		FOREIGN KEY (water_id) REFERENCES standing_water(water_id)
			ON DELETE RESTRICT
			ON UPDATE CASCADE,
	CONSTRAINT fk_standing_water_project_researches_project
		FOREIGN KEY (project_id) REFERENCES project(project_id)
			ON DELETE RESTRICT
			ON UPDATE CASCADE,
	CONSTRAINT pk_standing_water_project_researches
		PRIMARY KEY (water_id, project_id)
);


CREATE TABLE IF NOT EXISTS running_water_project_researches (
	water_id INTEGER,
	project_id INTEGER,
	CONSTRAINT fk_running_water_project_researches_running_water
		FOREIGN KEY (water_id) REFERENCES running_water(water_id)
			ON DELETE RESTRICT
			ON UPDATE CASCADE,
	CONSTRAINT fk_running_water_project_researches_project
		FOREIGN KEY (project_id) REFERENCES project(project_id)
			ON DELETE RESTRICT
			ON UPDATE CASCADE,
	CONSTRAINT pk_running_water_project_researches
		PRIMARY KEY (water_id, project_id)
);

