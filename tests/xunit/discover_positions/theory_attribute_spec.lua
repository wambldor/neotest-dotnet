local async = require("nio").tests
local plugin = require("neotest-dotnet")
local Tree = require("neotest.types").Tree

A = function(...)
  print(vim.inspect(...))
end

describe("discover_positions", function()
  require("neotest").setup({
    adapters = {
      require("neotest-dotnet"),
    },
  })

  async.it("should discover tests with inline parameters", function()
    local spec_file = "./tests/xunit/specs/theory_and_fact_mixed.cs"
    local spec_file_name = "theory_and_fact_mixed.cs"
    local positions = plugin.discover_positions(spec_file):to_list()

    local function get_expected_output(file_path, file_name)
      return {
        {
          id = file_path,
          name = file_name,
          path = file_path,
          range = { 0, 0, 18, 0 },
          type = "file",
        },
        {
          {
            id = file_path .. "::xunit.testproj1",
            is_class = false,
            name = "xunit.testproj1",
            path = file_path,
            range = { 0, 0, 17, 1 },
            type = "namespace",
          },
          {
            {
              id = file_path .. "::xunit.testproj1::UnitTest1",
              is_class = true,
              name = "UnitTest1",
              path = file_path,
              range = { 2, 0, 17, 1 },
              type = "namespace",
            },
            {
              {
                id = file_path .. "::xunit.testproj1::UnitTest1::Test1",
                is_class = false,
                name = "Test1",
                path = file_path,
                range = { 4, 1, 8, 2 },
                type = "test",
              },
            },
            {
              {
                id = file_path .. "::xunit.testproj1::UnitTest1::Test2",
                is_class = false,
                name = "Test2",
                path = file_path,
                range = { 10, 1, 16, 2 },
                type = "test",
              },
              {
                {
                  id = file_path .. "::xunit.testproj1::UnitTest1::Test2(a: 1)",
                  is_class = false,
                  name = "Test2(a: 1)",
                  path = file_path,
                  range = { 11, 12, 11, 15 },
                  type = "test",
                },
              },
              {
                {
                  id = file_path .. "::xunit.testproj1::UnitTest1::Test2(a: 2)",
                  is_class = false,
                  name = "Test2(a: 2)",
                  path = file_path,
                  range = { 12, 12, 12, 15 },
                  type = "test",
                },
              },
            },
          },
        },
      }
    end

    assert.same(positions, get_expected_output(spec_file, spec_file_name))
  end)

  async.it("should discover tests in block scoped namespace", function()
    local spec_file = "./tests/xunit/specs/block_scoped_namespace.cs"
    local positions = plugin.discover_positions(spec_file):to_list()

    local expected_positions = {
      {
        id = "./tests/xunit/specs/block_scoped_namespace.cs",
        name = "block_scoped_namespace.cs",
        path = "./tests/xunit/specs/block_scoped_namespace.cs",
        range = { 0, 0, 11, 0 },
        type = "file",
      },
      {
        {
          id = "./tests/xunit/specs/block_scoped_namespace.cs::xunit.testproj1",
          is_class = false,
          name = "xunit.testproj1",
          path = "./tests/xunit/specs/block_scoped_namespace.cs",
          range = { 0, 0, 10, 1 },
          type = "namespace",
        },
        {
          {
            id = "./tests/xunit/specs/block_scoped_namespace.cs::xunit.testproj1::UnitTest1",
            is_class = true,
            name = "UnitTest1",
            path = "./tests/xunit/specs/block_scoped_namespace.cs",
            range = { 2, 1, 9, 2 },
            type = "namespace",
          },
          {
            {
              id = "./tests/xunit/specs/block_scoped_namespace.cs::xunit.testproj1::UnitTest1::Test1",
              is_class = false,
              name = "Test1",
              path = "./tests/xunit/specs/block_scoped_namespace.cs",
              range = { 4, 2, 8, 3 },
              type = "test",
            },
          },
        },
      },
    }
    assert.same(positions, expected_positions)
  end)
end)
