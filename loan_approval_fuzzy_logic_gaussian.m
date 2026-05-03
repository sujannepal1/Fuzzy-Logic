% Load fuzzy toolkit
pkg load fuzzy-logic-toolkit

% Create FIS
fis = newfis('loan_approval', 'mamdani');

% add new variable
fis = addvar(fis, 'input', 'CreditScore', [300,850])
a = 850-300
interval = a/3
val = 350
fis = addmf(fis,'input', 1, 'Low', 'gaussmf', [40,val])
fis = addmf(fis,'input', 1, 'Medium', 'gaussmf', [40,val + interval])
fis = addmf(fis,'input', 1, 'High', 'gaussmf', [40,val + 2*interval])
plotmf(fis, 'input', 1);
waitforbuttonpress;

fis= addvar(fis, 'input', 'Income', [0,120000]);
fis=addmf(fis,'input', 2, 'Low', 'gaussmf', [10000,20000]);
fis=addmf(fis,'input', 2, 'Medium', 'gaussmf', [10000,60000]);
fis=addmf(fis,'input', 2, 'High', 'gaussmf', [10000,100000]);    
plotmf(fis, 'input', 2);
waitforbuttonpress;


fis = addvar(fis, 'input', 'Age', [18,70]);
fis = addmf(fis,'input', 3, 'Young', 'gaussmf', [3,25]);
fis = addmf(fis,'input', 3, 'Middle-aged', 'gaussmf', [5,40]);
fis = addmf(fis,'input', 3, 'Old', 'gaussmf', [4,60]); 
plotmf(fis, 'input', 3);
waitforbuttonpress;

writefis(fis, 'Q2_loan_approval_fis');


fis = addvar(fis, 'output', 'LoanApproval', [0 100]);
fis = addmf(fis, 'output', 1, 'Low', 'gaussmf', [15 25]);
fis = addmf(fis, 'output', 1, 'Medium', 'gaussmf', [15 50]);
fis = addmf(fis, 'output', 1, 'High', 'gaussmf', [15 75]);

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