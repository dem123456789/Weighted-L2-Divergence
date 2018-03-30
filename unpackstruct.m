function [] = unpackstruct(r)
% Get the field names of the structure.
fields = fieldnames(r, '-full');
% Find out how many there are - for our loop.
numberOfFields = length(fields);

for f = 1 : numberOfFields
    thisField = fields{f};
    commandLine = sprintf('%s = r.%s', thisField, thisField);
    eval(commandLine);
end
% Release temporary variables.
clear('f', 'thisField', 'numberOfFields');
clear('fields', 'commandLine');
% Release struct
clear('r');
save('out.mat');
end