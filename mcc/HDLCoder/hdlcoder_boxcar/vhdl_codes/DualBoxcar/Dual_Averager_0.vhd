-- -------------------------------------------------------------
-- 
-- File Name: hdl_prj\hdlsrc\DualBoxcarAveragerFixedPoint\Dual_Averager_0.vhd
-- Created: 2025-03-30 20:27:36
-- 
-- Generated by MATLAB 23.2, HDL Coder 23.2, and Simulink 23.2
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: Dual_Averager_0
-- Source Path: DualBoxcarAveragerFixedPoint/DSP/Dual_Averager_0
-- Hierarchy Level: 1
-- Model version: 6.42
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Dual_Averager_0 IS
  PORT( Clk                               :   IN    std_logic;
        Reset                             :   IN    std_logic;
        SignalInput                       :   IN    signed(15 DOWNTO 0);  -- int16
        Trigger                           :   IN    std_logic;
        TriggerDelay                      :   IN    unsigned(15 DOWNTO 0);  -- uint16
        GateLength                        :   IN    unsigned(15 DOWNTO 0);  -- uint16
        TriggerDelayBaseline              :   IN    unsigned(15 DOWNTO 0);  -- uint16
        AvgLength                         :   IN    unsigned(15 DOWNTO 0);  -- uint16
        DataOut                           :   OUT   signed(48 DOWNTO 0);  -- sfix49
        FlagOut                           :   OUT   signed(15 DOWNTO 0)  -- int16
        );
END Dual_Averager_0;


ARCHITECTURE rtl OF Dual_Averager_0 IS

  -- Component Declarations
  COMPONENT Single_Averager
    PORT( Clk                             :   IN    std_logic;
          Reset                           :   IN    std_logic;
          SignalInput                     :   IN    signed(15 DOWNTO 0);  -- int16
          Trigger                         :   IN    std_logic;
          TriggerDelay                    :   IN    unsigned(15 DOWNTO 0);  -- uint16
          GateLength                      :   IN    unsigned(15 DOWNTO 0);  -- uint16
          AvgLength                       :   IN    unsigned(15 DOWNTO 0);  -- uint16
          DataOut                         :   OUT   signed(47 DOWNTO 0);  -- sfix48
          AveragingFlag                   :   OUT   std_logic  -- ufix1
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : Single_Averager
    USE ENTITY work.Single_Averager(rtl);

  -- Signals
  SIGNAL switch_compare_1                 : std_logic;
  SIGNAL Switch_out1                      : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL Single_Averager_out2             : signed(47 DOWNTO 0);  -- sfix48
  SIGNAL Single_Averager_out3             : std_logic;  -- ufix1
  SIGNAL Single_Averager_Baseline_out2    : signed(47 DOWNTO 0);  -- sfix48
  SIGNAL Single_Averager_Baseline_out3    : std_logic;  -- ufix1
  SIGNAL Add2_out1                        : signed(48 DOWNTO 0);  -- sfix49
  SIGNAL Rescale_Convertor2_out1          : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL Convertor_OutputB2_out1          : signed(15 DOWNTO 0);  -- int16
  SIGNAL Rescale_Convertor3_out1          : signed(15 DOWNTO 0);  -- sfix16_En13
  SIGNAL Convertor_OutputB3_out1          : signed(15 DOWNTO 0);  -- int16
  SIGNAL Bitwise_AND1_out1                : signed(15 DOWNTO 0);  -- int16

BEGIN
  u_Single_Averager : Single_Averager
    PORT MAP( Clk => Clk,
              Reset => Reset,
              SignalInput => SignalInput,  -- int16
              Trigger => Trigger,
              TriggerDelay => TriggerDelay,  -- uint16
              GateLength => GateLength,  -- uint16
              AvgLength => Switch_out1,  -- uint16
              DataOut => Single_Averager_out2,  -- sfix48
              AveragingFlag => Single_Averager_out3  -- ufix1
              );

  u_Single_Averager_Baseline : Single_Averager
    PORT MAP( Clk => Clk,
              Reset => Reset,
              SignalInput => SignalInput,  -- int16
              Trigger => Trigger,
              TriggerDelay => TriggerDelayBaseline,  -- uint16
              GateLength => GateLength,  -- uint16
              AvgLength => Switch_out1,  -- uint16
              DataOut => Single_Averager_Baseline_out2,  -- sfix48
              AveragingFlag => Single_Averager_Baseline_out3  -- ufix1
              );

  
  switch_compare_1 <= '1' WHEN AvgLength > to_unsigned(16#0000#, 16) ELSE
      '0';

  
  Switch_out1 <= to_unsigned(16#0001#, 16) WHEN switch_compare_1 = '0' ELSE
      AvgLength;

  Add2_out1 <= resize(Single_Averager_out2, 49) - resize(Single_Averager_Baseline_out2, 49);

  Rescale_Convertor2_out1 <= signed(resize(unsigned'(Single_Averager_out3 & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0'), 16));

  Convertor_OutputB2_out1 <= Rescale_Convertor2_out1;

  Rescale_Convertor3_out1 <= signed(resize(unsigned'(Single_Averager_Baseline_out3 & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0'), 16));

  Convertor_OutputB3_out1 <= Rescale_Convertor3_out1;

  Bitwise_AND1_out1 <= Convertor_OutputB2_out1 OR Convertor_OutputB3_out1;

  DataOut <= Add2_out1;

  FlagOut <= Bitwise_AND1_out1;

END rtl;

