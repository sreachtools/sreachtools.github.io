%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name of the programmer: Joseph Gleason %
% Date: 2018-10-19                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Purpose
% Generate Markdown files from the docstrings

function docs2md(varargin)
    % Provide website base path if not <path-to-SReachTools/SReachTools-website

    global tabstr FUNCTION_BASE_PATH DOCS_BASE_PATH WEBSITE_BASE_PATH
    % Tab string
    tabstr = '';                                    
    % Where are we currently?
    FUNCTION_BASE_PATH = srtinit('--rootpath');
    if nargin == 0
        WEBSITE_BASE_PATH = sprintf('%s-website', FUNCTION_BASE_PATH);
    else
        WEBSITE_BASE_PATH = varargin{1};
    end
    % Location of the docs/_docs folder
    DOCS_BASE_PATH = fullfile(WEBSITE_BASE_PATH, '/_docs/');

    fprintf('\n')
    disp('Generating documentation using following file paths')
    fprintf('\n')
    fprintf('FUNCTION_BASE_PATH: %s\n', FUNCTION_BASE_PATH);
    fprintf('WEBSITE_BASE_PATH: %s\n', WEBSITE_BASE_PATH);
    fprintf('DOCS_BASE_PATH: %s\n', DOCS_BASE_PATH);
    fprintf('\n\n')
    
    %% Fetch data from the previous docs file - returns a cell of cell of cells
    fid_prev = fopen(fullfile(WEBSITE_BASE_PATH, './docs.md'), 'r');
    if fid_prev == -1
        error(['Incorrect website base path provided. Expected a file ', ...
            'titled docs.md at %s/docs.md'], WEBSITE_BASE_PATH)
    end
    file_prevcontents_cell = textscan(fid_prev, '%s', 'Delimiter', '\n');    
    fclose(fid_prev);
    
    %% Sanitize the file_prevcontents_cell for sprintf 
    file_prevcontents = strrep(file_prevcontents_cell{1}, '\', '\\');
    
    start_indx = find(contains(file_prevcontents, ...
        '<!-- DO NOT REMOVE: docs2md START FILE DUMP HERE -->')==1);
    end_indx = find(contains(file_prevcontents, ...
        '<!-- DO NOT REMOVE: docs2md END FILE DUMP HERE -->')==1);
    
    if length(start_indx) ~= 1 || length(end_indx) ~=1
        % Insert the following two snippets in the docs.md to mark the beginning
        % and end of file dump (excluding -----)
        % ---------------------------------------------------------------------
        %
        % <!-- DO NOT REMOVE: docs2md START FILE DUMP HERE -->
        %
        % ---------------------------------------------------------------------
        %
        % <!-- DO NOT REMOVE: docs2md END FILE DUMP HERE -->
        %
        % ---------------------------------------------------------------------
        error('Couldn''t find the start and end of the file dump!');
    end
    
    %% Recursively delete all files in the docs folder
    rmdir(DOCS_BASE_PATH, 's');
    checkAndMakeFolder(DOCS_BASE_PATH);

    %% Write the base docs index file
    % Open the file
    fid = fopen(fullfile(DOCS_BASE_PATH, 'index.md'), 'w+');
    % Copy the top content
    fprintf(fid, strjoin(file_prevcontents(1:start_indx),'\n'));
    % Add a new line and class list
    fprintf(fid,'\n\n<ul class="doc-list">\n');
    fclose(fid);
    % Write the list as well as create the corresponding help files
    checkAndMakeFolder(fullfile(DOCS_BASE_PATH, 'src'));
    tabstr = [tabstr, '    '];
    listAllFilesRecursive('src', FUNCTION_BASE_PATH);
    tabstr = '';
    % Add the finishing touches
    fid = fopen(fullfile(DOCS_BASE_PATH, 'index.md'), 'a');
    fprintf(fid, sprintf('%s</ul>\n\n', tabstr));
    % Copy the bottom content
    fprintf(fid, strjoin(file_prevcontents(end_indx:end),'\n'));
    fprintf(fid,'\n');    
    fclose(fid);
    
    % Overwrite the file to ../docs.md
    movefile([DOCS_BASE_PATH 'index.md'],[DOCS_BASE_PATH '../docs.md'])
end

function checkAndMakeFolder(fpath)
    if exist(fpath, 'dir') ~= 7
        % fprintf('Creating %s\n', fpath)
        try
            mkdir(fpath)
        catch err
            throw(SrtInternalError('Could not create directory %s', ...
                fpath));
        end
    end
end

function listAllFilesRecursive(folder_name, base_dir)

    global tabstr DOCS_BASE_PATH

    len_folder_name = length(folder_name);
    old_tabstr = tabstr;

    IGNORE_DIRS = {'.', '..', '.git'};

    % check if the folder is a class folder; currently not going to print
    % the contents of a class folder because this will get its own more
    % dedicated page

    if regexp(folder_name, '^@')
        const_name = fullfile(base_dir, folder_name, [folder_name(2:end) '.m']);
        if exist(const_name, 'file') == 2
            % found constructor, write class
            [cpath, cname, cext] = fileparts(const_name);
            
            fid = fopen(fullfile(DOCS_BASE_PATH, 'index.md'), 'a');
            fprintf(fid, sprintf(['%s<li class="doc-list"><a href="%s">', ...
                '%s/</a></li>\n'], ...
                tabstr, getLocalPath(const_name, 'toolbox'), folder_name));
            fclose(fid);

            writeClassPageDoc(const_name);
        else
            warning('Class file %s not found. Skipping...', const_name);
        end

        % fid = fopen(fullfile(DOCS_BASE_PATH, 'index.md'), 'a');
        % fprintf(fid, sprintf(['%s<li class="doc-list"><a href="#%s">%s/</a></li>\n'], tabstr, ...
        %     folder_name(2:end), folder_name));

        % fclose(fid);

        % checkAndMakeFolder(functionPath2DocsPath(fullfile(base_dir, ...
        %     folder_name(2:end))));

        % if exist(fullfile(base_dir, folder_name, ...
        %     [folder_name(2:end) '.m']), 'file') == 2

        %     writeClassPageDoc(fullfile(base_dir, folder_name, ...
        %         [folder_name(2:end) '.m']));
        % else
        %     warning('Class file %s not found. Skipping...', ...
        %         fullfile(base_dir, folder_name, [folder_name(2:end) '.m']));
        % end

        return;
    end

    dl = dir(fullfile(base_dir, folder_name));

    fid = fopen(fullfile(DOCS_BASE_PATH, 'index.md'), 'a');
    fprintf(fid, sprintf('%s<li>%s/</li>\n', tabstr, folder_name));
    fprintf(fid, sprintf('%s<ul class="doc-list">\n', tabstr));
    fclose(fid);
    tabstr = [tabstr, '    '];

    for lv = 1:length(dl)
        if any(strcmp(dl(lv).name, IGNORE_DIRS))
            continue;
        end

        if dl(lv).isdir
            listAllFilesRecursive(dl(lv).name, dl(lv).folder);
        else
            fname = fullfile(dl(lv).folder, dl(lv).name);
            [~, name, ext] = fileparts(fname);
            if any(strcmp(ext, {'.m', '.matlab'}))
                fid = fopen(fullfile(DOCS_BASE_PATH, 'index.md'), 'a');
                switch name
                    case {'allcomb','qscmvnv'}
                        fprintf(fid, ...
                            sprintf(['%s<li class="doc-list"><a href="%s">',...
                                '%s </a> (Third-party code distributed with',...
                                ' license information)</li>\n'], ...
                            tabstr, getLocalPath(fname, 'toolbox'), ...
                            [name, ext]));
                    otherwise
                        fprintf(fid, ...
                            sprintf(['%s<li class="doc-list"><a href="%s">',...
                                '%s</a></li>\n'], ...
                            tabstr, getLocalPath(fname, 'toolbox'), ...
                            [name, ext]));
                end
                fclose(fid);

                writeDocStringToFile(fname);
            end
        end
    end

    tabstr = old_tabstr;
    fid = fopen(fullfile(DOCS_BASE_PATH, 'index.md'), 'a');
    fprintf(fid, sprintf('%s</ul>\n', tabstr));
    fclose(fid);
%     movefile(strcat(DOCS_BASE_PATH','index.md'),strcat(DOCS_BASE_PATH','../docs.md'));
end

function localpath = getLocalPath(file_name, opt)

    global FUNCTION_BASE_PATH DOCS_BASE_PATH

    switch(opt)
        case 'toolbox'
            file_name = functionPath2DocsPath(file_name);
            localpath = getLocalPath(file_name, 'doc');
        case 'doc'
            ln = length(DOCS_BASE_PATH);

            % eliminate the preamble
            localpath = file_name(ln+1:end);

            % get rid of the .md
            localpath = localpath(1:end-3);

            % add index.md
            % localpath = fullfile(localpath, 'index.md');
        otherwise
            error('Unhandled option')
    end
end

function writeDocStringToFile(file_name)

    global FUNCTION_BASE_PATH DOCS_BASE_PATH

    [fpath, fname, fext] = fileparts(file_name);

    metaobj = meta.class.fromName(fname);

    if ~isempty(metaobj);
        writeClassPageDoc(file_name);
    else
        writeFunctionPageDoc(file_name);
    end
end

function docsPath = functionPath2DocsPath(file_name)

    global FUNCTION_BASE_PATH DOCS_BASE_PATH

    % need to remove the function path and replace it with the docs path
    si = length(FUNCTION_BASE_PATH) + 2;

    [p, ~, file_ext] = fileparts(file_name);

    switch(file_ext)
        case '.m'
            % remove the .m and replace with .md
            file_name = fullfile(DOCS_BASE_PATH, file_name(si:end-2));
            file_name = [file_name, '.md'];
        case '.matlab'
            % remove the .matlab and replace with .md
            file_name = fullfile(DOCS_BASE_PATH, file_name(si:end-7));
            file_name = [file_name, '.md'];
        case ''
            file_name = fullfile(DOCS_BASE_PATH, file_name(si:end));
        otherwise
            error('Unhandled file option')
    end

    docsPath = file_name;
end

function writeFunctionPageDoc(file_name)
    [fun_path, fun_name, ext] = fileparts(file_name);

    [md_path, md_name, ~] = fileparts(functionPath2DocsPath(file_name));

    % create the base folder so that can write to /some/path/index.md
    checkAndMakeFolder(fullfile(md_path, md_name))

    fprintf('Writing %s ...\n', fullfile(md_path, md_name, 'index.md'));
    % write index.md
    fid = fopen(fullfile(md_path, md_name, 'index.md'), 'w+');
    fprintf(fid, '---\n');
    fprintf(fid, 'layout: docs\n');

    % function name with extension for title
    fprintf(fid, 'title: %s\n', [fun_name, ext]);
    fprintf(fid, '---\n\n');
    
    % Copy over the help string
    hstr = help(file_name);    
    fprintf(fid, '```\n%s```\n', hstr);
    
    switch fun_name
        case 'allcomb'
            % Get license info
            flic = fopen(strcat(fun_path, '/allcomb_license.txt'),'r');
            license_txt_cell = textscan(flic, '%s', 'Delimiter', '\n');
            fclose(flic);
            
            % Add license
            license_txt = strrep(license_txt_cell{1}, '\', '\\');
            fprintf(fid, '\n\n\n## License\n');
            fprintf(fid, ...
                ['Available at ',...
                 '`./src/helperFunctions/allcomb_license.txt`.\n\n']);
            fprintf(fid, strjoin(license_txt,'\n'));
        otherwise
    end
    % Close the filename
    fclose(fid);
end

function writeClassPageDoc(ffpath)

    [class_path, class_name, ext] = fileparts(ffpath);

    atinds = regexp(class_path, '@');
    offset = 0;
    for lv = 1:length(atinds)
        class_path = class_path(1:atinds(lv)-offset-1);
        offset = offset + 1;
    end

    tabstr = '';

    md_name = functionPath2DocsPath(ffpath);
    md_path = md_name(1:end-3);

    fprintf('Writing %s ...\n', fullfile(md_path, 'index.md'));
    checkAndMakeFolder(md_path);

    fid = fopen(fullfile(md_path, 'index.md'), 'w+');
    fprintf(fid, '---\n');
    fprintf(fid, 'layout: docs\n');

    metaobj = meta.class.fromName(class_name);
    disp_property_count = 0;
    disp_method_count = 0;

    % for lv = 1:length(metaobj.PropertyList)
    %     if metaobj.PropertyList(lv).Hidden || ...
    %         strcmp(metaobj.PropertyList(lv).GetAccess, 'private')

    %     else
    %         disp_property_count

    % function name with extension for title
    fprintf(fid, 'title: %s\n', [class_name, ext]);
    fprintf(fid, '---\n\n');

    fprintf(fid, '%s<ul %s>\n', tabstr, getUlClassStr());
    tabstr = incrementTab(tabstr);
    % +1 tab inc
    fprintf(fid, '%s<li %s><a href="%s">%s</a></li>\n', tabstr, ...
        getLiClassStr(), ['#', metaobj.Name], metaobj.Name);
    fprintf(fid, '%s<ul %s>\n', tabstr, getUlClassStr());
    tabstr = incrementTab(tabstr);
    % +2 tab inc

    fprintf(fid, '%s<li><a href="%s">Constructor</a></li>\n', tabstr, ...
        ['#' metaobj.Name '-' metaobj.Name]);

    fprintf(fid, '%s<li>Properties</li>\n', tabstr);
    fprintf(fid, '%s<ul %s>\n', tabstr, getUlClassStr());
    tabstr = incrementTab(tabstr);
    % +3 tab inc
    for lv = 1:length(metaobj.PropertyList)
        if isDispProperty(metaobj, lv)

            fprintf(fid, '%s<li %s><a href="%s">%s</a></li>\n', ...
                tabstr, ...
                getLiClassStr(), ...
                ['#' metaobj.Name '-prop-' metaobj.PropertyList(lv).Name], ...
                metaobj.PropertyList(lv).Name);
        end
    end
    tabstr = decrementTab(tabstr);
    % +2 tab inc
    fprintf(fid, '%s</ul>\n', tabstr);

    fprintf(fid, '%s<li>Methods</li>\n', tabstr);
    fprintf(fid, '%s<ul %s>\n', tabstr, getUlClassStr());
    tabstr = incrementTab(tabstr);
    % +3 tab inc
    for lv = 1:length(metaobj.MethodList)
        if isDispMethod(metaobj, lv)

            fprintf(fid, '%s<li %s><a href="%s">%s</a></li>\n', ...
                tabstr, ...
                getLiClassStr(), ...
                ['#' metaobj.Name '-method-' metaobj.MethodList(lv).Name], ...
                metaobj.MethodList(lv).Name);
        end
    end
    tabstr = decrementTab(tabstr);
    % +2 tab inc
    fprintf(fid, '%s</ul>\n', tabstr);


    tabstr = decrementTab(tabstr);
    % +1 tab inc
    fprintf(fid, '%s</ul>\n', tabstr);

    tabstr = decrementTab(tabstr);
    % +0 tab inc
    fprintf(fid, '%s</ul>\n', tabstr);


    fprintf(fid, '\n');

    % print the main help
    fprintf(fid, '{:#%s}\n', class_name);
    fprintf(fid, '### %s\n', class_name);
    fprintf(fid, '```\n%s```\n\n', help(class_name));

    % print constructor help
    fprintf(fid, '{:#%1$s-%1$s}\n', class_name);
    fprintf(fid, '### Constructor\n');
    fprintf(fid, '```\n%s```\n\n', help(class_name));

    % print the help for properties
    for lv = 1:length(metaobj.PropertyList)
        if isDispProperty(metaobj, lv)

            fprintf(fid, '### %s\n', ...
                ['Property: ' metaobj.PropertyList(lv).Name]);
            fprintf(fid, '{:#%s-prop-%s}\n', ...
                class_name, metaobj.PropertyList(lv).Name);
            hstr = help([class_name, '.', metaobj.PropertyList(lv).Name]);
            if isempty(hstr)
                fprintf(fid, ['{%% include important-note.html ', ...
                    'content="Property currently has no help ', ...
                    'documentation." %%}\n']);
            else
                fprintf(fid, '```\n%s```\n', help([class_name, '.', ...
                    metaobj.PropertyList(lv).Name]));
            end
            fprintf(fid, '\n');
        end
    end

    % print the help for methods
    for lv = 1:length(metaobj.MethodList)
        if isDispMethod(metaobj, lv)

            fprintf(fid, '### %s\n', ...
                ['Method: ' metaobj.MethodList(lv).Name]);
            fprintf(fid, '{:#%s-method-%s}\n', ...
                class_name, metaobj.MethodList(lv).Name);
            hstr = help([class_name, '.', metaobj.MethodList(lv).Name]);
            if isempty(hstr)
                fprintf(fid, ['{%% include important-note.html ', ...
                    'content="Method currently has no help ', ...
                    'documentation." %%}\n']);
            else
                fprintf(fid, '```\n%s```\n', help([class_name, '.', ...
                    metaobj.MethodList(lv).Name]));
            end
            fprintf(fid, '\n');
        end
    end

    fclose(fid);
end

function tabstr = incrementTab(tabstr)
    tabstr = [tabstr, '    '];
end

function tabstr = decrementTab(tabstr)
    tabstr = tabstr(1:end-4);
end

function str = getLiClassStr()
    str = 'class="doc-list"';
end

function str = getUlClassStr()
    str = 'class="doc-list"';
end

function bool = isDispMethod(mo, ind)
    ol_methods = {'subsref', 'subsassn', 'length', 'size', 'disp', ...
        'end'};

    bool = ~mo.MethodList(ind).Hidden && ...
            strcmp(mo.MethodList(ind).Access, 'public') && ...
            ~any(strcmp(mo.MethodList(ind).Name, ol_methods)) && ...
            ~strcmp(mo.MethodList(ind).Name, mo.Name) && ...
            mo.MethodList(ind).DefiningClass == mo;
end

function bool = isDispProperty(mo, ind)
    bool = ~mo.PropertyList(ind).Hidden && ...
            strcmp(mo.PropertyList(ind).GetAccess, 'public') && ...
            mo.PropertyList(ind).DefiningClass == mo;
end
