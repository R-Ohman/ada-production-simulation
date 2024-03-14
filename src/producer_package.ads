with Product_Assemblies; use Product_Assemblies;
with buffer_package; use buffer_package;


package producer_package is
   
  
   -- Producer produces determined product
   task type Producer is
      -- Give the Producer an identity, i.e. the product type
      entry Start(Product: in Product_Type; Production_Time: in Integer);
   end Producer;

end producer_package;
