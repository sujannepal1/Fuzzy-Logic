% Load fuzzy toolkit
pkg load fuzzy-logic-toolkit

% Create FIS
fis = newfis('loan_approval_trapmf', 'mamdani');

% add new variable
fis = addvar(fis, 'input', 'CreditScore', [300,850])
fis = addmf(fis,'input', 1, 'Low', 'trapmf', [0 300 400 420])
fis = addmf(fis,'input', 1, 'Medium', 'trapmf', [380 450 600 670])
fis = addmf(fis,'input', 1, 'High', 'trapmf', [650 710 750 850])
plotmf(fis, 'input', 1);
waitforbuttonpress;

fis= addvar(fis, 'input', 'Income', [0,120000]);
fis=addmf(fis,'input', 2, 'Low', 'trapmf', [0 10000 25000 40000]);
fis=addmf(fis,'input', 2, 'Medium', 'trapmf', [30000 40000 60000 70000]);
fis=addmf(fis,'input', 2, 'High', 'trapmf', [60000 80000 110000 130000]);    
plotmf(fis, 'input', 2);
waitforbuttonpress;


fis = addvar(fis, 'input', 'Age', [18,70]);
fis = addmf(fis,'input', 3, 'Young', 'trapmf', [18 22 36 40]);
fis = addmf(fis,'input', 3, 'Middle-aged', 'trapmf', [38 45 53 60]);
fis = addmf(fis,'input', 3, 'Old', 'trapmf', [58 62 72 80]); 
plotmf(fis, 'input', 3);
waitforbuttonpress;

writefis(fis, 'Q4a_loan_approval_trapmf_fis');
fis = addvar(fis, 'output', 'LoanApproval', [0, 100]);
fis = addmf(fis, 'output', 1, 'Low', 'trapmf', [0 15 20 25]);
fis = addmf(fis, 'output', 1, 'Medium', 'trapmf', [25 35 65 75]);
fis = addmf(fis, 'output', 1, 'High', 'trapmf', [75 85 95 100]);

%rule defining
rules = [

 3 3 3 2 1 2,
 1 1 0 1 1 1,

 1 2 1 1 1 1,
 1 2 2 1 1 1,
 1 2 3 2 1 1,
 1 3 1 2 1 1,
 1 3 2 2 1 1,
 1 3 3 2 1 1,


 2 1 1 1 1 1,
 2 1 2 2 1 1,
 2 1 3 2 1 1,
 2 2 1 2 1 1,
 2 2 2 2 1 1,
 2 2 3 2 1 1,
 2 3 1 2 1 1,
 2 3 2 3 1 1,
 2 3 3 3 1 1,


 3 1 1 2 1 1,
 3 1 2 2 1 1,
 3 1 3 3 1 1,
 3 2 1 2 1 1,
 3 2 2 3 1 1,
 3 2 3 3 1 1,
 3 3 1 3 1 1,
 3 3 2 3 1 1,
 3 3 3 3 1 1,

 ];

 fis = addrule(fis, rules);
 showrule(fis);


 output = evalfis([400 50000 30], fis);
 printf('Loan Approval: %.2f\n', output);
 methods = {'centroid', 'bisector', 'mom', 'som', 'lom'};
 test_in = [600, 80000, 35]; 

 for i = 1:length(methods)
     fis.defuzzMethod = methods{i};
     result = evalfis(test_in, fis);
     printf('Method: %s \t Result: %.2f\n', methods{i}, result);
 end
