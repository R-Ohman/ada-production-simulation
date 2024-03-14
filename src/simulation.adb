with Tasks; use Tasks;
with Product_Assemblies; use Product_Assemblies;
with producer_package; use producer_package;

procedure Simulation is
   P : array (1 .. Number_Of_Products) of Producer;
   K : array (1 .. Number_Of_Consumers) of Consumer;
   

begin
   for I in 1 .. Number_Of_Products loop
      P (I).Start (I, 10);
   end loop;
   for J in 1 .. Number_Of_Consumers loop
      K (J).Start (J, 12);
   end loop;
end Simulation;
