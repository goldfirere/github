-----------------------------------------------------------------------------
-- |
-- License     :  BSD-3-Clause
-- Maintainer  :  Oleg Grenrus <oleg.grenrus@iki.fi>
--
-- The pull requests API as documented at
-- <http://developer.github.com/v3/pulls/reviews>.
module GitHub.Endpoints.PullRequests.Reviews (
--    pullRequestReviews,
    pullRequestReviewsR,
--    pullRequestReviews',
    pullRequestReviewSubmitR
    ) where

import GitHub.Data
import GitHub.Internal.Prelude
import Prelude ()

-- | List pull request reviews, by owner, repo, and pull request number
pullRequestReviewsR
    :: Name Owner
    -> Name Repo
    -> Int          -- PR number, NOT id
    -> Request k (Vector PullRequestReview)
pullRequestReviewsR user repo prnum = query
    ["repos", toPathPart user, toPathPart repo, "pulls", pack (show prnum), "reviews"] []


-- | Submit a pull request review, by owner, repo, PR number, and review id
pullRequestReviewSubmitR
    :: Name Owner
    -> Name Repo
    -> Int        -- ^ PR number
    -> Id PullRequestReview
    -> Text       -- ^ body of review
    -> PullRequestReviewAction
    -> Request 'RW PullRequestReview
pullRequestReviewSubmitR user repo prnum reviewid body action = command Post
    [ "repos", toPathPart user, toPathPart repo, "pulls", pack (show prnum), "reviews"
    , toPathPart reviewid, "events" ]
    (encode (object ["body" .= body, "event" .= action]))
