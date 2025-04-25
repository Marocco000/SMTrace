using Printf

const WORKING_DIR = Ref("")
const RESULTS_DIR = Ref("")
const RUN_DIR = Ref("")

function set_working_dir(working_dir)
    WORKING_DIR[] = working_dir
    RESULTS_DIR[] = WORKING_DIR[] * "/results/"

    isdir(RESULTS_DIR[]) || mkdir(RESULTS_DIR[])
end

function set_current_run()

    # get all entries that look like Run-XX
    entries = filter(name -> occursin(r"^Run-\d\d$", name), readdir(RESULTS_DIR[]))

    # extract numbers
    nums = parse.(Int, replace.(entries, "Run-" => ""))
    next_id = isempty(nums) ? 0 : maximum(nums) + 1

    # build folder name
    run_name = @sprintf("Run-%02d", next_id)
    RUN_DIR[] = joinpath(RESULTS_DIR[], run_name) * "/"

    # mkpath(RUN_DIR[])
    isdir(RUN_DIR[]) || mkdir(RUN_DIR[])

    create_dir_structure_Run()

    return RUN_DIR
end

function create_dir_structure_Run() #TODO for RUN_DIR
    isdir(RUN_DIR[] * "parsing_results") || mkdir(RUN_DIR[] * "parsing_results")
    isdir(RUN_DIR[] * "solver_results") || mkdir(RUN_DIR[] * "solver_results")
    isdir(RUN_DIR[] * "figures") || mkdir(RUN_DIR[] * "figures")
end

