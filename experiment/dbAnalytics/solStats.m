load('solStats')

barh(obs.clInstrument)
set(gca, 'ytick', 1:length(instrumentNames));
set(gca, 'yticklabels', instrumentNames);

barh(obs.clFamily)
set(gca, 'ytick', 1:length(familyNames));
set(gca, 'yticklabels', familyNames);

barh(obs.clMode)
set(gca, 'ytick', 1:length(modeNames));
set(gca, 'yticklabels', modeNames);

[obs.clmodeFamily, ind] = sort(obs.clmodeFamily);
barh(obs.clmodeFamily)
set(gca, 'ytick', 1:length(modeFamilyNames));
set(gca, 'yticklabels', modeFamilyNames(ind));
set(gca,'xscale','log')

selector = [16:21 ceil(length(modeFamilyNames)/2-2:length(modeFamilyNames)/2+2) length(modeFamilyNames)-5:length(modeFamilyNames)];
barh(obs.clmodeFamily(selector))
obs.clmodeFamily(selector)
set(gca, 'ytick', 1:length(modeFamilyNames(selector)));
set(gca, 'yticklabels', modeFamilyNames(ind(selector)));
set(gca,'xscale','log')



