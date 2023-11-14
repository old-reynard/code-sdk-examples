({
  author: 'Tanner Philp',
  date: 'October 25, 2023',
  title: 'Early Release of the Code SDK',
  description:
    'We just released an early first version of the Code SDK. This is the payments experience we’ve always wanted after more than a decade building mainstream consumer apps and developer platforms.',
})

%%%
<Author :name="author" :date="date" />

## We just released an early first version of the Code SDK. This is the payments experience we’ve always wanted after more than a decade building mainstream consumer apps and developer platforms.

<Fadeout text="The challenge with existing payment platforms is they are incredibly limiting. As a developer you have to sign up for an account, provide a bunch of information, and often wait for approvals. " />

%%%

Once you’re through, you’re constrained to specific geographies with varying capabilities, so you have to build different experiences for different audiences. And on top of that you have to pay high fees. At a minimum, you’re paying $0.30-$1.00 for each card transaction with an additional take rate of 3-10%.

We’ve talked to senior people at every major payment platform, and every major card issuer over the last 10+ years and every single one has said those are hard constraints. We hear over and over that they’d love to offer a different experience, but the business model just doesn’t work. When you have the risk of chargeback (inherent in all fiat payment rails), you have to do anti-fraud work and build in a financial buffer for the fraud that inevitably slips through.

That’s one of the things that got us excited about micropayments for the web. It’s a use case that everyone wants – eg. pay 25 cents to unlock an individual article instead of signing up for a perpetual subscription – and is uniquely enabled with crypto. Because crypto is open, and there’s no chargeback risk since payments are atomic.

There are a number of other compelling experiences crypto – and really only Code with its novel and robust infrastructure – uniquely enables that we are excited about. Those will be introduced in future versions of the Code SDK. 

For now we are starting simple and empowering web developers to charge their users anywhere from 5 to 100 cents. We wanted to get this first experience and the first set of the docs in the hands of web developers as quickly as possible to get valuable feedback as we continue to refine and build on both the developer experience and the user experience.

The best way to help if you’re a web developer is to try and build something with the Code SDK, show it off publicly, and share your experience with the developer community on Discord. We’ve already had a number of first experiences go live and great discussion in Discord that has informed tweaks to the SDK and documentation.

If you’re not a developer, the best way to help _for now_ is to try the different experiences (including this one) and share your feedback publicly. We are working on something that will empower everyone to create their own payment experiences with zero development requirement, so the options for non-developers will be expanding soon. Stay tuned for that.

Like I said at the top, we’ve built the payments experience we’ve always wanted, but we are building this for everyone. We believe open, permissionless payments with no concessions on the user experience you want to deliver is incredibly empowering and will give rise to new and exciting experiences not previously considered possible. So if you have ideas on what you want to see, or have contributions you’d like to make (eg. modules, plugins, libraries) please follow us on [Twitter](https://twitter.com/getcode) and join our [Discord](https://discord.gg/v6cJfSSA).

Lastly, we should expect that a lot of the first experiences will be simple, experimental, and have rough edges. I share this not to make assumptions about what will be built (I’ve already seen a number of strong individuals and teams jump in and start building some really slick experiences) but to say that not everything will be or should be perfect. In the early phase of this platform it’s about exploring what's possible. So I encourage everyone to build, ship, and iterate.

We’ll certainly be doing the same, with lots of testing of course.

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Today we&#39;re releasing an early version of the Code SDK.<br><br>With just a few lines of code any web developer can now charge users as little as 5 cents.<br><br>Our goal with this release is to get feedback as we build out the experience and the docs.<br><br>Get started at: <a href="https://t.co/wGG5c4mTul">https://t.co/wGG5c4mTul</a></p>&mdash; Code (@getcode) <a href="https://twitter.com/getcode/status/1714826767263809820?ref_src=twsrc%5Etfw">October 19, 2023</a></blockquote>

<br>

**Note: This post is intended as an example of the Code micropayments experience. I’ve set up a dedicated wallet to receive these payments and will use the proceeds exclusively to pay for other Code micropayments experiences built by the community.**
