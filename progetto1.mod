

#DEFINIZIONE INSIEMI
set T;
set T1;


#DEFINIZIONE PARAMETRI

param T1_num;
#numeri di elementi dell'insieme T', serve per calcolare produzione_max

param c;
#costo c euro a tonnellata per produzione ordinaria

param cp;
#costo cp euro a tonnellata per produzione straordinaria

param cg;
#costo cg euro a tonnellata per giacenza

param perc;
#percentuale della produzione totale dei primi T' mesi che deve essere
#uguale alla produzione ordinaria dei mesi successivi

param prod_str_max;
#produrre in straordinario aumentando la capacità mensile al più di prod_str_max

param domanda{T} >= 0;
#parametro che riguarda la domanda mensile


#DEFINIZIONE VARIABILI

var cap_prod{T} >= 0, integer;
#produzione ordinaria per ciascun mese

var prod_str{T} >= 0;
#produzione straordinaria per ciascun mese

var giacenze{T} >= 0, integer;
#giacenze a fine mese

var prod_T1{T1} >=0, integer;
#produzione per ciascun mese nei primi T' mesi

var prod_tot_T1 >=0, integer;
#produzione totale nei primi T' mesi


#DEFINIZIONE VINCOLI

subject to produzione_T1  {i in T1} :
prod_T1[i] = cap_prod[i] + prod_str[i];
#calcolo produzione nei primi T' mesi

subject to prod_totale_T1 :
prod_tot_T1 = sum{i in T1}prod_T1[i];
#calcolo produzione totale nei primi T' mesi

subject to produzione  {i in T} :
cap_prod[i] + prod_str[i] = domanda[i] + giacenze[i];
#produzione ordinaria + produzione straordinaria = domanda + giacenza

subject to produzione_str  {i in T} :
prod_str[i] <= prod_str_max;
#produrre in straordinario aumentando la capacità mensile al più di prod_str_max

subject to produzione_max {i in T: i>T1_num} : 
cap_prod[i] >= perc/100*(prod_tot_T1);
#parametro corrispondente ai primi T’ mesi e poi per ogni mese la produzione ordinaria di 
#ogni mese impostata a una percentuale perc della produzione (ordinaria) di quei primi T' mesi


#DEFINIZIONE OBIETTIVO

minimize tot_valore : sum{i in T}cap_prod[i]*c +
	sum{i in T}prod_str[i]*cp + sum{i in T}giacenze[i]*cg;
#pianificazione produzione a costo minimo
	

