return {
  version = "1.4",
  luaversion = "5.1",
  tiledversion = "1.4.2",
  orientation = "orthogonal",
  renderorder = "right-down",
  canDash = true,
  hasEnemy = true,
  width = 27,
  height = 20,
  tilewidth = 30,
  tileheight = 30,
  nextlayerid = 7,
  nextobjectid = 36,
  properties = {},
  tilesets = {
    {
      name = "map",
      firstgid = 1,
      tilewidth = 30,
      tileheight = 30,
      spacing = 0,
      margin = 0,
      columns = 5,
      image = "Sprite/map/groundTiled.png",
      imagewidth = 150,
      imageheight = 30,
      objectalignment = "unspecified",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 30,
        height = 30
      },
      properties = {},
      terrains = {},
      tilecount = 5,
      tiles = {}
    },
    {
      name = "Torch",
      firstgid = 6,
      tilewidth = 30,
      tileheight = 30,
      spacing = 0,
      margin = 0,
      columns = 4,
      image = "Sprite/object/Torch.png",
      imagewidth = 120,
      imageheight = 30,
      objectalignment = "unspecified",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 30,
        height = 30
      },
      properties = {},
      terrains = {},
      tilecount = 4,
      tiles = {
        {
          id = 0,
          animation = {
            {
              tileid = 0,
              duration = 250
            },
            {
              tileid = 1,
              duration = 250
            },
            {
              tileid = 2,
              duration = 250
            },
            {
              tileid = 3,
              duration = 250
            }
          }
        }
      }
    },
    {
      name = "triangle",
      firstgid = 10,
      tilewidth = 30,
      tileheight = 30,
      spacing = 0,
      margin = 0,
      columns = 5,
      image = "Sprite/ennemies/Enemy.png",
      imagewidth = 150,
      imageheight = 30,
      objectalignment = "unspecified",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 30,
        height = 30
      },
      properties = {},
      terrains = {},
      tilecount = 5,
      tiles = {
        {
          id = 0,
          animation = {
            {
              tileid = 0,
              duration = 250
            },
            {
              tileid = 1,
              duration = 250
            },
            {
              tileid = 2,
              duration = 250
            },
            {
              tileid = 3,
              duration = 250
            },
            {
              tileid = 4,
              duration = 250
            }
          }
        }
      }
    },
    {
      name = "arrow",
      firstgid = 15,
      tilewidth = 30,
      tileheight = 30,
      spacing = 0,
      margin = 0,
      columns = 0,
      objectalignment = "unspecified",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 1,
        height = 1
      },
      properties = {},
      terrains = {},
      tilecount = 2,
      tiles = {
        {
          id = 0,
          image = "Sprite/object/tile-arrow-left.png",
          width = 30,
          height = 30
        },
        {
          id = 1,
          image = "Sprite/object/tile-arrow-right.png",
          width = 30,
          height = 30
        }
      }
    }
  },
  layers = {
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 27,
      height = 20,
      id = 1,
      name = "InvisibleLayer",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 1, 1, 1, 0, 1,
        1, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 1, 0, 1,
        1, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 5, 5, 0, 0, 1, 0, 0, 1, 3, 0, 0, 1, 0, 0, 1,
        1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1,
        1, 0, 1, 0, 0, 0, 0, 4, 1, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 1, 1,
        1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 5, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1,
        1, 1, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1,
        1, 0, 0, 1, 1, 0, 1, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 1,
        1, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1,
        1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 3, 0, 1, 0, 0, 0, 0, 1,
        1, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1,
        1, 3, 4, 1, 1, 1, 1, 1, 1, 3, 5, 5, 5, 5, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 27,
      height = 20,
      id = 2,
      name = "VisibleLayer",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 0, 1, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 4, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 3,
      name = "Triangle",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {
        ["type"] = "triangle",
        ["vx"] = 5
      },
      objects = {
        {
          id = 22,
          name = "",
          type = "",
          shape = "rectangle",
          x = 330,
          y = 210,
          width = 30,
          height = 30,
          rotation = 0,
          gid = 10,
          visible = true,
          properties = {
            ["type"] = "triangle",
            ["vx"] = 5
          }
        },
        {
          id = 25,
          name = "",
          type = "",
          shape = "rectangle",
          x = 210,
          y = 120,
          width = 30,
          height = 30,
          rotation = 0,
          gid = 10,
          visible = true,
          properties = {
            ["type"] = "triangle",
            ["vx"] = 5
          }
        },
        {
          id = 30,
          name = "",
          type = "",
          shape = "rectangle",
          x = 600,
          y = 480,
          width = 30,
          height = 30,
          rotation = 0,
          gid = 10,
          visible = true,
          properties = {
            ["type"] = "triangle",
            ["vx"] = 5
          }
        },
        {
          id = 33,
          name = "",
          type = "",
          shape = "rectangle",
          x = 720,
          y = 570,
          width = 30,
          height = 30,
          rotation = 0,
          gid = 10,
          visible = true,
          properties = {
            ["type"] = "triangle",
            ["vx"] = 5
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 4,
      name = "TriangleInvertVx",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      objects = {
        {
          id = 23,
          name = "",
          type = "",
          shape = "rectangle",
          x = 270,
          y = 210,
          width = 30,
          height = 30,
          rotation = 0,
          gid = 16,
          visible = true,
          properties = {
            ["pointing"] = "right",
            ["type"] = "direction"
          }
        },
        {
          id = 24,
          name = "",
          type = "",
          shape = "rectangle",
          x = 390,
          y = 210,
          width = 30,
          height = 30,
          rotation = 0,
          gid = 15,
          visible = true,
          properties = {
            ["pointing"] = "left",
            ["type"] = "direction"
          }
        },
        {
          id = 26,
          name = "",
          type = "",
          shape = "rectangle",
          x = 150,
          y = 120,
          width = 30,
          height = 30,
          rotation = 0,
          gid = 16,
          visible = true,
          properties = {
            ["pointing"] = "right",
            ["type"] = "direction"
          }
        },
        {
          id = 28,
          name = "",
          type = "",
          shape = "rectangle",
          x = 270,
          y = 120,
          width = 30,
          height = 30,
          rotation = 0,
          gid = 15,
          visible = true,
          properties = {
            ["pointing"] = "left",
            ["type"] = "direction"
          }
        },
        {
          id = 31,
          name = "",
          type = "",
          shape = "rectangle",
          x = 570,
          y = 480,
          width = 30,
          height = 30,
          rotation = 0,
          gid = 16,
          visible = true,
          properties = {
            ["pointing"] = "right",
            ["type"] = "direction"
          }
        },
        {
          id = 32,
          name = "",
          type = "",
          shape = "rectangle",
          x = 630,
          y = 480,
          width = 30,
          height = 30,
          rotation = 0,
          gid = 15,
          visible = true,
          properties = {
            ["pointing"] = "left",
            ["type"] = "direction"
          }
        },
        {
          id = 34,
          name = "",
          type = "",
          shape = "rectangle",
          x = 660,
          y = 570,
          width = 30,
          height = 30,
          rotation = 0,
          gid = 16,
          visible = true,
          properties = {
            ["pointing"] = "right",
            ["type"] = "direction"
          }
        },
        {
          id = 35,
          name = "",
          type = "",
          shape = "rectangle",
          x = 750,
          y = 570,
          width = 30,
          height = 30,
          rotation = 0,
          gid = 15,
          visible = true,
          properties = {
            ["pointing"] = "left",
            ["type"] = "direction"
          }
        }
      }
    }
  }
}
