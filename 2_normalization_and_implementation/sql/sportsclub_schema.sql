CREATE TABLE IF NOT EXISTS public.target_group (
	t_code CHAR(3) PRIMARY KEY,
	description VARCHAR(50)
);


CREATE TYPE public.gender AS ENUM ('f', 'm');


CREATE TABLE IF NOT EXISTS public.member (
	mem_name VARCHAR(255) PRIMARY KEY,
	is_trainer BOOLEAN,
	email VARCHAR(255),
	postal_code INTEGER,
	date_of_birth DATE,
	gender gender,
	entry_date DATE,
	parent VARCHAR(255),
	CONSTRAINT fk_member_member
		FOREIGN KEY (parent) REFERENCES public.member(mem_name)
			ON UPDATE CASCADE,
	CONSTRAINT chk_entry_date_range
		CHECK (entry_date > '2015-01-01' AND entry_date <= CURRENT_DATE),
	CONSTRAINT chk_parent_self_reference
		CHECK (parent IS NULL OR parent <> mem_name),
	CONSTRAINT chk_child_has_parent
		CHECK (AGE(CURRENT_DATE, date_of_birth) >= INTERVAL '18 years' OR PARENT IS NOT NULL)
);


CREATE TABLE IF NOT EXISTS public.trainer (
	mem_name VARCHAR(255) PRIMARY KEY,
	license BOOLEAN,
	start_date DATE,
	CONSTRAINT fk_trainer_member
		FOREIGN KEY (mem_name) REFERENCES public.member(mem_name)
			ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS public.area (
	area VARCHAR(255) PRIMARY KEY,
	description VARCHAR(255),
	manager VARCHAR(255),
	CONSTRAINT fk_area_trainer
		FOREIGN KEY (manager) REFERENCES public.trainer(mem_name) 
			ON DELETE SET NULL
			ON UPDATE CASCADE,
	CONSTRAINT uc_area_manager
		UNIQUE (manager)
);


CREATE TABLE IF NOT EXISTS public.course (
	course_id SERIAL PRIMARY KEY,
	course_name VARCHAR(255),
	target_group CHAR(3),
	area VARCHAR(255),
	mem_name VARCHAR(255),
	CONSTRAINT fk_course_target_group
		FOREIGN KEY (target_group) REFERENCES public.target_group(t_code) 
			ON DELETE RESTRICT
			ON UPDATE CASCADE,
	CONSTRAINT fk_course_area
		FOREIGN KEY (area) REFERENCES public.area(area) 
			ON DELETE SET NULL
			ON UPDATE CASCADE,
	CONSTRAINT fk_course_trainer
		FOREIGN KEY (mem_name) REFERENCES public.trainer(mem_name) 
			ON DELETE RESTRICT
			ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS public.enrollment (
	mem_name VARCHAR(255),
	course_id SERIAL,
	CONSTRAINT fk_enrollment_member
		FOREIGN KEY (mem_name) REFERENCES public.member(mem_name)
			ON DELETE CASCADE
			ON UPDATE CASCADE,
	CONSTRAINT fk_enrollment_course
		FOREIGN KEY (course_id) REFERENCES public.course(course_id)
			ON DELETE RESTRICT
			ON UPDATE CASCADE,
	CONSTRAINT pk_enrollment
		PRIMARY KEY (mem_name, course_id)
);


CREATE TABLE IF NOT EXISTS public.device (
	device_id SERIAL PRIMARY KEY,
	dev_name VARCHAR(255)
);


CREATE TABLE IF NOT EXISTS public.reservation (
	timeslot TIMESTAMP,
	mem_name VARCHAR(255),
	device_id SERIAL,
    CONSTRAINT pk_reservation
        PRIMARY KEY (timeslot, mem_name),
	CONSTRAINT fk_reservation_member
		FOREIGN KEY (mem_name) REFERENCES public.member(mem_name)
			ON DELETE CASCADE
			ON UPDATE CASCADE,
	CONSTRAINT fk_reservation_device
		FOREIGN KEY (device_id) REFERENCES public.device(device_id)
			ON DELETE RESTRICT
			ON UPDATE CASCADE,
	CONSTRAINT uc_reservation_timeslot_device_id
		UNIQUE (timeslot, device_id)
);