--
-- Copyright (c) 2017 XXXX, UPC
-- All rights reserved.
-- 

library ieee;
use ieee.std_logic_1164.all;

use work.param_disenyo_pkg.all;
use work.interface_cache_bus_pkg.all;
use work.componentes_interfaces_bus_pkg.all;
use work.componentes_memoria_pkg.all;
use work.multis_pkg.all;
use work.interface_observador_pkg.all;
use work.bus_multi_pkg.all;
--! @image html mem_inter_bus.png 

entity mem_con_interface_bus is 										
	port(reloj, pcero: in  std_logic;
		mpet_info_bus: in tp_peticion_info;
		mresp_info_bus: out tp_bus_info_resp;
		obs_s: out tp_bus_observacion;
		mpet_cntl_bus: in tp_peticion_control;
		mresp_cntl_bus: out tp_bus_control_resp); 
end mem_con_interface_bus;


architecture estructural of mem_con_interface_bus is

signal mpet_info_s: tp_peticion_info;
signal mresp_info_e: tp_bus_info_resp;

signal mpet_cntl_s: tp_peticion_control;
signal mresp_cntl_e: tp_bus_control_resp;

signal LD, ED_mem: st_elem_dat;
signal dir_mem: st_dir;
signal MPET_mem, MLES_mem, MEXP_mem: std_logic;
signal iden: iden_proc;
signal obs_e: tp_bus_observacion;

signal respt_cnt_mem: tp_bus_control_resp;
signal mresp_LD: tp_bus_info_resp;

begin
-- interface con el bus: informacion
inter_Mem_BUS_IN: interface_mem_bus_info port map(reloj => reloj, pcero => pcero, 
												mpet_info_bus => mpet_info_bus, mpet_info_s => mpet_info_s, 
												mresp_info_e => mresp_info_e, mresp_info_bus => mresp_info_bus);

-- interconexiones
dir_mem <= mpet_info_s.dir;
ED_mem <= mpet_info_s.dato_E; 

mresp_info_e <= mresp_LD;

-- interface con el bus: informacion
inter_Mem_BUS_CON_obs: interface_mem_bus_control port map (reloj => reloj, pcero => pcero, 
												mpet_cntl_bus => mpet_cntl_bus, mpet_cntl_s => mpet_cntl_s, 
												obs_e => obs_e, obs_s => obs_s,
												mresp_cntl_e => mresp_cntl_e, mresp_cntl_bus => mresp_cntl_bus);

-- interconexiones
MPET_mem <= mpet_cntl_s.mpet;
MLES_mem <= mpet_cntl_s.mles;
MEXP_mem <= mpet_cntl_s.mexp;

mresp_cntl_e <= respt_cnt_mem;

iden <= mpet_cntl_s.iden;

-- memoria
memoria: ensamblado_memoria port map (reloj => reloj, ED => ED_mem, dir => dir_mem, MPET => MPET_mem, MLES => MLES_mem, MEXP => MEXP_mem, iden => iden, obs_s => obs_e, respt_cnt_mem => respt_cnt_mem, mresp_LD => mresp_LD);

end;

