-- Insert yourself as trainer with memname 'yourfirstname_yourlastname
INSERT INTO public.member (
    mem_name, is_trainer, email, postal_code, 
    date_of_birth, gender, entry_date
) 
VALUES (
    'rezi_gelenidze', TRUE, 'rezi.gelenidze@xx.ge', 4600, 
    '2000-01-01', 'm', '2024-10-10'
);

INSERT INTO public.trainer (
    mem_name, license, start_date
) 
VALUES (
    'rezi_gelenidze', TRUE, '2024-10-10'
);


-- Set yourself as manager of one of the areas.
SELECT * FROM area WHERE area='fitness';

UPDATE public.area 
	SET manager='rezi_gelenidze' 
	WHERE area=1;

SELECT * FROM area WHERE area='fitness';


-- Insert your TA as member with memname 'tafirstname_talastname
INSERT INTO public.member (
    mem_name, is_trainer, email, postal_code, 
    date_of_birth, gender, entry_date
) 
VALUES (
    'anastasia_sulukhia', TRUE, 'a.sulukhia@xx.ge', 4600, 
    '2003-01-01', 'f', '2024-10-24'
);


-- Make a device reservation for yourself
INSERT INTO public.device (dev_name) VALUES ('treadmill');
INSERT INTO public.device (dev_name) VALUES ('bench');

INSERT INTO public.reservation (
	timeslot, mem_name, device_id 
)
VALUES (
	'2024-10-25 14:00:00', 'rezi_gelenidze', 1
);

-- Verify that it is NOT possible for you to reserve multiple devices for the same timestamp:
INSERT INTO public.reservation (
	timeslot, mem_name, device_id 
)
VALUES (
	'2024-10-25 14:00:00', 'rezi_gelenidze', 2
);

-- duplicate key value violates unique constraint "pk_reservation"

INSERT INTO public.reservation (
	timeslot, mem_name, device_id 
)
VALUES (
	'2024-10-25 14:00:00', 'anastasia_sulukhia', 1
);


-- duplicate key value violates unique constraint "uc_reservation_timeslot_device_id"