return {
  version = "1.4",
  luaversion = "5.1",
  tiledversion = "1.4.2",
  orientation = "orthogonal",
  renderorder = "right-down",
  canDash = true,
  hasEnemy = false,
  width = 27,
  height = 20,
  tilewidth = 30,
  tileheight = 30,
  nextlayerid = 5,
  nextobjectid = 13,
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
      visible = false,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
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
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        5, 5, 0, 0, 0, 0, 0, 0, 5, 5, 0, 0, 0, 5, 5, 5, 0, 5, 5, 5, 0, 5, 0, 0, 5, 0, 5,
        5, 0, 5, 0, 0, 0, 0, 0, 5, 0, 5, 0, 0, 5, 0, 5, 0, 5, 0, 0, 0, 5, 0, 0, 5, 0, 5,
        5, 0, 0, 5, 0, 0, 0, 0, 5, 0, 0, 5, 0, 5, 0, 5, 0, 5, 0, 0, 0, 5, 0, 0, 5, 0, 5,
        5, 0, 0, 5, 0, 5, 5, 0, 5, 0, 0, 5, 0, 5, 5, 5, 0, 5, 0, 0, 0, 5, 5, 5, 5, 0, 5,
        5, 0, 0, 5, 0, 0, 0, 0, 5, 0, 0, 5, 0, 5, 0, 5, 0, 5, 5, 5, 0, 5, 0, 0, 5, 0, 5,
        5, 0, 0, 5, 0, 5, 5, 0, 5, 0, 0, 5, 0, 5, 0, 5, 0, 0, 0, 5, 0, 5, 0, 0, 5, 0, 5,
        5, 0, 5, 0, 0, 0, 0, 0, 5, 0, 5, 0, 0, 5, 0, 5, 0, 0, 0, 5, 0, 5, 0, 0, 5, 0, 5,
        5, 5, 0, 0, 0, 0, 0, 0, 5, 5, 0, 0, 0, 5, 0, 5, 0, 5, 5, 5, 0, 5, 0, 0, 5, 0, 5,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 1,
        1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
      }
    }
  }
}
