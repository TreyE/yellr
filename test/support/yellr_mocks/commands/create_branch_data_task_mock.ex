defmodule YellrMocks.Commands.CreateBranchDataTaskMock do

  use ModuleMocker

  define_mock(
    :enqueue_create_initial_build_result,
    [
      branch_id,
      initial_status
    ]
  )
end
