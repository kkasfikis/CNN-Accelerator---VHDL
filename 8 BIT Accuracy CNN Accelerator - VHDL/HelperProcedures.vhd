
library IEEE;
use IEEE.STD_LOGIC_1164.all;
USE ieee.numeric_std.ALL;

package HelperProcedures is
	procedure signed_addition_64with32bit(
		value1 : in std_logic_vector(31 downto 0);
		value2 : in std_logic_vector(63 downto 0);
		result : out std_logic_vector(63 downto 0)
	);
	procedure signed_addition_9with9bit(
		value1 : in std_logic_vector(8 downto 0);
		value2 : in std_logic_vector(8 downto 0);
		result : out std_logic_vector(15 downto 0)
	);
	procedure signed_addition_32with32bit(
		value1 : in std_logic_vector(31 downto 0);
		value2 : in std_logic_vector(31 downto 0);
		result : out std_logic_vector(31 downto 0)
	);
end HelperProcedures;

package body HelperProcedures is
	
	procedure signed_addition_64with32bit(
		value1 : in std_logic_vector(31 downto 0);
		value2 : in std_logic_vector(63 downto 0);
		result : out std_logic_vector(63 downto 0)
	) is
	begin
		if(value1(31) = '1') then
			if(value2(63) = '1') then
				result := '1' & std_logic_vector(resize(unsigned(value1(30 downto 0)),63) + unsigned(value2(62 downto 0)));
			else
				if(to_integer(unsigned(value1(30 downto 0)))>to_integer(unsigned(value2))) then
					result := '1' & std_logic_vector(resize(unsigned(value1(30 downto 0)),63) - unsigned(value2(62 downto 0)));
				elsif(to_integer(unsigned(value1(30 downto 0)))<to_integer(unsigned(value2))) then
					result := '0' & std_logic_vector(unsigned(value2(62 downto 0)) - resize(unsigned(value1(30 downto 0)),63));
				else
					result := "0000000000000000000000000000000000000000000000000000000000000000";
				end if;
			end if;
		else
			if (value2(63) = '1') then
				if(to_integer(unsigned(value2(62 downto 0))) > to_integer(unsigned(value1))) then
					result := '1' & std_logic_vector(unsigned(value2(62 downto 0)) - resize(unsigned(value1),63));
				elsif(to_integer(unsigned(value2(62 downto 0))) < to_integer(unsigned(value1))) then
					result := '0' & std_logic_vector(resize(unsigned(value1),63) - unsigned(value2(62 downto 0)));
				else
					result := "0000000000000000000000000000000000000000000000000000000000000000";
				end if;
			else
				result := std_logic_vector(resize(unsigned(value1),64) + unsigned(value2));
			end if;
		end if;		
	end procedure;
	
	procedure signed_addition_9with9bit(
		value1 : in std_logic_vector(8 downto 0);
		value2 : in std_logic_vector(8 downto 0);
		result : out std_logic_vector(15 downto 0)
	) is
	begin
		if(value1(8) = '1') then
			if(value2(8) = '1') then
				result(7 downto 0) := std_logic_vector(unsigned(value1(7 downto 0)) + unsigned(value2(7 downto 0)));
				result(15 downto 8) := (others => '1');
			else
				if(to_integer(unsigned(value1(7 downto 0)))>to_integer(unsigned(value2))) then
					result(7 downto 0) := std_logic_vector(unsigned(value1(7 downto 0)) - unsigned(value2(7 downto 0)));
					result(15 downto 8) := (others => '1');
				elsif(to_integer(unsigned(value1(7 downto 0)))<to_integer(unsigned(value2))) then
					result(7 downto 0) := std_logic_vector(unsigned(value2(7 downto 0)) - unsigned(value1(7 downto 0)));
					result(15 downto 8) := (others => '0');
				else
					result := "0000000000000000";
				end if;
			end if;
		else
			if (value2(8) = '1') then
				if(to_integer(unsigned(value2(7 downto 0))) > to_integer(unsigned(value1))) then
					result(7 downto 0) := std_logic_vector(unsigned(value2(7 downto 0)) - unsigned(value1(7 downto 0)));
					result(15 downto 8) := (others => '1');
				elsif(to_integer(unsigned(value2(7 downto 0))) < to_integer(unsigned(value1))) then
					result(7 downto 0) := std_logic_vector(unsigned(value1(7 downto 0)) - unsigned(value2(7 downto 0)));
					result(15 downto 8) := (others => '0');
				else
					result := "0000000000000000";
				end if;
			else
				result := std_logic_vector(unsigned(value1) + unsigned(value2));
			end if;
		end if;		
	end procedure;

	procedure signed_addition_32with32bit(
		value1 : in std_logic_vector(31 downto 0);
		value2 : in std_logic_vector(31 downto 0);
		result : out std_logic_vector(31 downto 0)
	) is
	begin
		if(value1(31) = '1') then
			if(value2(31) = '1') then
				result := '1' & std_logic_vector(unsigned(value1(30 downto 0)) + unsigned(value2(30 downto 0)));
			else
				if(to_integer(unsigned(value1(30 downto 0)))>to_integer(unsigned(value2))) then
					result := '1' & std_logic_vector(unsigned(value1(30 downto 0)) - unsigned(value2(30 downto 0)));
				elsif(to_integer(unsigned(value1(30 downto 0)))<to_integer(unsigned(value2))) then
					result := '0' & std_logic_vector(unsigned(value2(30 downto 0)) - unsigned(value1(30 downto 0)));
				else
					result := "00000000000000000000000000000000";
				end if;
			end if;
		else
			if (value2(31) = '1') then
				if(to_integer(unsigned(value2(30 downto 0))) > to_integer(unsigned(value1))) then
					result := '1' & std_logic_vector(unsigned(value2(30 downto 0)) - unsigned(value1(30 downto 0)));
				elsif(to_integer(unsigned(value2(30 downto 0))) < to_integer(unsigned(value1))) then
					result := '0' & std_logic_vector(unsigned(value1(30 downto 0)) - unsigned(value2(30 downto 0)));
				else
					result := "00000000000000000000000000000000";
				end if;
			else
				result := std_logic_vector(unsigned(value1) + unsigned(value2));
			end if;
		end if;		
	end procedure;
	
end HelperProcedures;
