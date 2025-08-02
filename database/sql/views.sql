-- Vista para propiedades disponibles con información completa
create view
  data.v_available_properties as
select
  p.pro_id,
  p.pro_title,
  p.pro_description,
  pt.pty_name as property_type,
  p.pro_sale_price,
  p.pro_rental_price,
  p.pro_total_area,
  p.pro_bedrooms,
  p.pro_bathrooms,
  a.add_main_street,
  c.cit_name as city,
  pr.pro_name as province,
  ag.age_id as agent_id,
  per.per_first_name || ' ' || per.per_first_last_name as agent_name,
  per_phone.pho_number as agent_phone
from
  data.data_property p
  join data.data_property_type pt on p.id_property_type = pt.pty_id
  join data.data_property_status ps on p.id_property_status = ps.pst_id
  join data.data_address a on p.id_address = a.add_id
  join core.core_city c on a.id_city = c.cit_id
  join core.core_province pr on a.id_province = pr.pro_id
  left join data.data_agent ag on p.id_agent = ag.age_id
  left join data.data_person per on ag.id_person = per.per_id
  left join data.data_phone per_phone on per.per_id = per_phone.id_person
where
  ps.pst_name = 'disponible'
  and p.pro_record_status = '0';

-- Vista para seguimiento de ventas por agente
create view
  data.v_agent_performance as
select
  ag.age_id,
  per.per_first_name || ' ' || per.per_first_last_name as agent_name,
  count(distinct con.con_id) filter (
    where
      ct.cty_name = 'venta'
      and date_part('year', con.con_signed_date) = date_part('year', current_date)
  ) as sales_this_year,
  count(distinct con.con_id) filter (
    where
      ct.cty_name = 'alquiler'
      and date_part('year', con.con_signed_date) = date_part('year', current_date)
  ) as rentals_this_year,
  sum(con.con_commission_amount) filter (
    where
      date_part('year', con.con_signed_date) = date_part('year', current_date)
  ) as total_commission_this_year,
  count(distinct app.app_id) filter (
    where
      app.app_status = 'completed'
      and date_part('month', app.app_date) = date_part('month', current_date)
  ) as visits_this_month
from
  data.data_agent ag
  join data.data_person per on ag.id_person = per.per_id
  left join data.data_contract con on ag.age_id = con.id_agent
  and con.con_status = 'active'
  left join data.data_contract_type ct on con.id_contract_type = ct.cty_id
  left join data.data_appointment app on ag.age_id = app.id_agent
where
  ag.age_record_status = '0'
group by
  ag.age_id,
  per.per_first_name,
  per.per_first_last_name;