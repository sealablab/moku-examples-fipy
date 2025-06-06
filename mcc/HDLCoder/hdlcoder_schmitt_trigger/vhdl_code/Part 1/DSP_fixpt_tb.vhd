-- -------------------------------------------------------------
-- 
-- File Name: E:\Liquid Instruments Dropbox\Fengyuan Deng\Projects\_Collaborative_Projects\2021-0908-HDLCoderTutorial\_Code\_MATLAB_NEWPORTNAME\codegen\DSP\hdlsrc\DSP_fixpt_tb.vhd
-- Created: 2021-09-29 19:18:52
-- 
-- Generated by MATLAB 9.10, MATLAB Coder 5.2 and HDL Coder 3.18
-- 
-- 
-- 
-- -------------------------------------------------------------
-- Rate and Clocking Details
-- -------------------------------------------------------------
-- Model base rate: 1
-- Target subsystem base rate: 1
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: DSP_fixpt_tb
-- Source Path: 
-- Hierarchy Level: 0
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_textio.ALL;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY STD;
USE STD.textio.ALL;
USE work.DSP_fixpt_tb_pkg.ALL;

ENTITY DSP_fixpt_tb IS
END DSP_fixpt_tb;


ARCHITECTURE rtl OF DSP_fixpt_tb IS

  -- Component Declarations
  COMPONENT DSP_fixpt
    PORT( Clk                             :   IN    std_logic;
          Reset                           :   IN    std_logic;
          InputA                          :   IN    signed(15 DOWNTO 0);  -- int16
          OutputA                         :   OUT   signed(15 DOWNTO 0)  -- int16
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : DSP_fixpt
    USE ENTITY work.DSP_fixpt(rtl);

  -- Signals
  SIGNAL Clk                              : std_logic;
  SIGNAL Reset                            : std_logic;
  SIGNAL enb                              : std_logic;
  SIGNAL OutputA_done                     : std_logic;  -- ufix1
  SIGNAL rdEnb                            : std_logic;
  SIGNAL OutputA_done_enb                 : std_logic;  -- ufix1
  SIGNAL OutputA_addr                     : unsigned(13 DOWNTO 0);  -- ufix14
  SIGNAL OutputA_active                   : std_logic;  -- ufix1
  SIGNAL check1_done                      : std_logic;  -- ufix1
  SIGNAL snkDonen                         : std_logic;
  SIGNAL resetn                           : std_logic;
  SIGNAL tb_enb                           : std_logic;
  SIGNAL ce_out                           : std_logic;
  SIGNAL OutputA_enb                      : std_logic;  -- ufix1
  SIGNAL OutputA_lastAddr                 : std_logic;  -- ufix1
  SIGNAL InputA_addr                      : unsigned(13 DOWNTO 0);  -- ufix14
  SIGNAL InputA_active                    : std_logic;  -- ufix1
  SIGNAL InputA_enb                       : std_logic;  -- ufix1
  SIGNAL InputA_addr_delay_1              : unsigned(13 DOWNTO 0);  -- ufix14
  SIGNAL rawData_InputA                   : signed(15 DOWNTO 0);  -- int16
  SIGNAL holdData_InputA                  : signed(15 DOWNTO 0);  -- int16
  SIGNAL InputA_offset                    : signed(15 DOWNTO 0);  -- int16
  SIGNAL InputA_1                         : signed(15 DOWNTO 0);  -- int16
  SIGNAL OutputA_1                        : signed(15 DOWNTO 0);  -- int16
  SIGNAL OutputA_addr_delay_1             : unsigned(13 DOWNTO 0);  -- ufix14
  SIGNAL OutputA_expected                 : signed(15 DOWNTO 0);  -- int16
  SIGNAL OutputA_ref                      : signed(15 DOWNTO 0);  -- int16
  SIGNAL OutputA_testFailure              : std_logic;  -- ufix1

BEGIN
  u_DSP_fixpt : DSP_fixpt
    PORT MAP( Clk => Clk,
              Reset => Reset,
              InputA => InputA_1,  -- int16
              OutputA => OutputA_1  -- int16
              );

  OutputA_done_enb <= OutputA_done AND rdEnb;

  
  OutputA_active <= '1' WHEN OutputA_addr /= to_unsigned(16#270F#, 14) ELSE
      '0';

  enb <= rdEnb AFTER 2 ns;

  snkDonen <=  NOT check1_done;

  Clk_gen: PROCESS 
  BEGIN
    Clk <= '1';
    WAIT FOR 5 ns;
    Clk <= '0';
    WAIT FOR 5 ns;
    IF check1_done = '1' THEN
      Clk <= '1';
      WAIT FOR 5 ns;
      Clk <= '0';
      WAIT FOR 5 ns;
      WAIT;
    END IF;
  END PROCESS Clk_gen;

  Reset_gen: PROCESS 
  BEGIN
    Reset <= '1';
    WAIT FOR 20 ns;
    WAIT UNTIL Clk'event AND Clk = '1';
    WAIT FOR 2 ns;
    Reset <= '0';
    WAIT;
  END PROCESS Reset_gen;

  resetn <=  NOT Reset;

  tb_enb <= resetn AND snkDonen;

  
  rdEnb <= tb_enb WHEN check1_done = '0' ELSE
      '0';

  ce_out <= enb AND (rdEnb AND tb_enb);

  OutputA_enb <= ce_out AND OutputA_active;

  -- Count limited, Unsigned Counter
  --  initial value   = 0
  --  step value      = 1
  --  count to value  = 9999
  OutputA_process : PROCESS (Clk)
  BEGIN
    IF Clk'EVENT AND Clk = '1' THEN
      IF Reset = '1' THEN
        OutputA_addr <= to_unsigned(16#0000#, 14);
      ELSIF OutputA_enb = '1' THEN
        IF OutputA_addr >= to_unsigned(16#270F#, 14) THEN 
          OutputA_addr <= to_unsigned(16#0000#, 14);
        ELSE 
          OutputA_addr <= OutputA_addr + to_unsigned(16#0001#, 14);
        END IF;
      END IF;
    END IF;
  END PROCESS OutputA_process;


  
  OutputA_lastAddr <= '1' WHEN OutputA_addr >= to_unsigned(16#270F#, 14) ELSE
      '0';

  OutputA_done <= OutputA_lastAddr AND resetn;

  -- Delay to allow last sim cycle to complete
  checkDone_1_process: PROCESS (Clk)
  BEGIN
    IF Clk'event AND Clk = '1' THEN
      IF Reset = '1' THEN
        check1_done <= '0';
      ELSIF OutputA_done_enb = '1' THEN
        check1_done <= OutputA_done;
      END IF;
    END IF;
  END PROCESS checkDone_1_process;

  
  InputA_active <= '1' WHEN InputA_addr /= to_unsigned(16#270F#, 14) ELSE
      '0';

  InputA_enb <= InputA_active AND (rdEnb AND tb_enb);

  -- Count limited, Unsigned Counter
  --  initial value   = 0
  --  step value      = 1
  --  count to value  = 9999
  InputA_process : PROCESS (Clk)
  BEGIN
    IF Clk'EVENT AND Clk = '1' THEN
      IF Reset = '1' THEN
        InputA_addr <= to_unsigned(16#0000#, 14);
      ELSIF InputA_enb = '1' THEN
        IF InputA_addr >= to_unsigned(16#270F#, 14) THEN 
          InputA_addr <= to_unsigned(16#0000#, 14);
        ELSE 
          InputA_addr <= InputA_addr + to_unsigned(16#0001#, 14);
        END IF;
      END IF;
    END IF;
  END PROCESS InputA_process;


  InputA_addr_delay_1 <= InputA_addr AFTER 1 ns;

  -- Data source for InputA
  InputA_fileread: PROCESS (InputA_addr_delay_1, tb_enb, rdEnb)
    FILE fp: TEXT open READ_MODE is "InputA.dat";
    VARIABLE l: LINE;
    VARIABLE read_data: std_logic_vector(15 DOWNTO 0);

  BEGIN
    IF tb_enb /= '1' THEN
    ELSIF rdEnb = '1' AND NOT ENDFILE(fp) THEN
      READLINE(fp, l);
      HREAD(l, read_data);
    END IF;
    rawData_InputA <= signed(read_data(15 DOWNTO 0));
  END PROCESS InputA_fileread;

  -- holdData reg for InputA
  stimuli_InputA_process: PROCESS (Clk)
  BEGIN
    IF Clk'event AND Clk = '1' THEN
      IF Reset = '1' THEN
        holdData_InputA <= (OTHERS => 'X');
      ELSE
        holdData_InputA <= rawData_InputA;
      END IF;
    END IF;
  END PROCESS stimuli_InputA_process;

  stimuli_InputA_1: PROCESS (rawData_InputA, rdEnb)
  BEGIN
    IF rdEnb = '0' THEN
      InputA_offset <= holdData_InputA;
    ELSE
      InputA_offset <= rawData_InputA;
    END IF;
  END PROCESS stimuli_InputA_1;

  InputA_1 <= InputA_offset AFTER 2 ns;

  OutputA_addr_delay_1 <= OutputA_addr AFTER 1 ns;

  -- Data source for OutputA_expected
  OutputA_expected_fileread: PROCESS (OutputA_addr_delay_1, tb_enb, rdEnb)
    FILE fp: TEXT open READ_MODE is "OutputA_expected.dat";
    VARIABLE l: LINE;
    VARIABLE read_data: std_logic_vector(15 DOWNTO 0);

  BEGIN
    IF tb_enb /= '1' THEN
    ELSIF rdEnb = '1' AND NOT ENDFILE(fp) THEN
      READLINE(fp, l);
      HREAD(l, read_data);
    END IF;
    OutputA_expected <= signed(read_data(15 DOWNTO 0));
  END PROCESS OutputA_expected_fileread;

  OutputA_ref <= OutputA_expected;

  OutputA_1_checker: PROCESS (Clk, Reset)
  BEGIN
    IF Reset = '1' THEN
      OutputA_testFailure <= '0';
    ELSIF Clk'event AND Clk = '1' THEN
      IF ce_out = '1' AND OutputA_1 /= OutputA_ref THEN
        OutputA_testFailure <= '1';
        ASSERT FALSE
          REPORT "Error in OutputA_1: Expected " & to_hex(OutputA_ref) & (" Actual " & to_hex(OutputA_1))
          SEVERITY ERROR;
      END IF;
    END IF;
  END PROCESS OutputA_1_checker;

  completed_msg: PROCESS (Clk)
  BEGIN
    IF Clk'event AND Clk = '1' THEN
      IF check1_done = '1' THEN
        IF OutputA_testFailure = '0' THEN
          ASSERT FALSE
            REPORT "**************TEST COMPLETED (PASSED)**************"
            SEVERITY NOTE;
        ELSE
          ASSERT FALSE
            REPORT "**************TEST COMPLETED (FAILED)**************"
            SEVERITY NOTE;
        END IF;
      END IF;
    END IF;
  END PROCESS completed_msg;

END rtl;

