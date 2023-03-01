--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}

import Hakyll

--------------------------------------------------------------------------------
config :: Configuration
config = defaultConfiguration
  { destinationDirectory = "docs"
  }

main :: IO ()
main = hakyllWith config $ do
  match "images/*" $ do
    route idRoute
    compile copyFileCompiler

  match "css/*" $ do
    route idRoute
    compile compressCssCompiler

  match "math-practice-1/index.md" $ do
    route $ setExtension "html"
    compile $ do
      posts <- loadAll "math-practice-1/posts/*"
      let parCtx = perClassCtx "math-practice-1" "수학연습 1"
          ctx = listField "posts" parCtx (pure posts) <> parCtx
      pandocCompiler
        >>= loadAndApplyTemplate "templates/post-list.html" ctx
        >>= loadAndApplyTemplate "templates/default.html" ctx
        >>= relativizeUrls

  match "math-practice-1/posts/*" $ do
    route $ setExtension "html"
    let ctx = perClassCtx "math-practice-1" "수학연습 1"
    compile $
      pandocCompiler
        >>= loadAndApplyTemplate "templates/post.html" ctx
        >>= loadAndApplyTemplate "templates/default.html" ctx
        >>= relativizeUrls

  match "templates/*" $ compile templateBodyCompiler

--------------------------------------------------------------------------------
perClassCtx :: String -> String -> Context String
perClassCtx dirName className =
  mconcat
    [ constField "directory" dirName
    , constField "class" className
    , defaultContext
    ]
