library IEEE;
use IEEE.Std_Logic_1164.all;
use IEEE.Std_Logic_arith.all;
use IEEE.Std_Logic_unsigned.all;
 
Entity Divider Is
port(
	clk            : in  std_logic;
	rst            : in  std_logic;
	activation_request            : in  std_logic;
	divident        : in  std_logic_vector(31 downto 0);
	divider      : in  std_logic_vector(31 downto 0);
	activation_acknowledge              : out std_logic;
	Quotient           : out std_logic_vector(31 downto 0);
	remainder              : out std_logic_vector(31 downto 0)
);
end;
 
architecture Division_RTL of Divider is
	constant ALL_ZERO : std_Logic_vector(31 downto 0) := "00000000000000000000000000000000";
	signal ni : std_logic_vector(63 downto 0);
	signal sub : std_logic_vector(63 downto 0);
	signal n : std_logic_vector(63 downto 0);
	signal i : std_logic_vector(63 downto 0);
	signal d : std_logic_vector(63 downto 0);
	signal d_int : std_logic_vector(31 downto 0);
	signal counter : std_logic_vector(5 downto 0);
	signal ReadTempo : Std_Logic;
 
begin
 
    activation_acknowledge <= ReadTempo;
    NI(63 downto 0) <= ALL_ZERO & divident;
    D(30 downto 0) <= "0000000000000000000000000000000";
    D(62 downto 31) <= d_int;
    D(63) <= '0';
    Quotient <=n(31 downto 0);
    remainder <=n(63 downto 32);
    
    Process(rst, ReadTempo, n ,d )
    Begin
        If rst = '1' Then
            sub <= (Others=>'0');
        ElsIf ReadTempo = '0' Then
            sub<= n - d;
        Else
            sub <= (Others=>'0');
        End If;
    End Process;
    
    Process(clk, rst, ReadTempo)
    begin
        If rst = '1' Then
            n(63 downto 0) <= (Others=>'0');
            D_Int(31 downto 0) <= (others=>'0');
        ElsIf Rising_Edge(clk) Then
            If activation_request='1' Then
                n(63 downto 0) <= NI(63 downto 0);
                D_int(31 downto 0) <= divider(31 downto 0);
            Else    
                If ReadTempo ='0' Then
                    n(63 downto 0)    <= I(63 downto 0);
                End If;
            End If;
        End If;
    End Process;
 
    Process(rst, Sub, n, ReadTempo)
    Begin
        If rst = '1' Then
            I <=  (others=>'0');
        ElsIf ReadTempo ='0' Then
            If Sub(47)='1' Then
                I(0)    <='0';
                I(63 Downto 1)    <= N(62 Downto 0);
            Else
                I(0)    <='1';
                I(63 Downto 1)    <= Sub(62 Downto 0);
            End If;
         Else
            I <=  (others=>'0');
         End If;
    End process;
 
    Process(clk,rst)
    Begin
        If rst = '1' Then
            counter <="111111";
            ReadTempo <= '0';
        ElsIf Rising_Edge(clk) Then
            If activation_request = '1' Then
                Counter <= (Others=>'0');
                ReadTempo <= '0';
            Else    
                If counter="011111" Then
                    counter <="111111";
                    ReadTempo <= '1';
                Elsif counter="011110" Then
                    counter <=counter+'1';
                    ReadTempo <= '0';
                Elsif counter="111111" Then
                    ReadTempo <='1';
                Else
                    counter <=counter+'1';
                    ReadTempo <='0';
                End if;    
            End If;    
        End If;
    End Process;
End;