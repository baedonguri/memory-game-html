# 🧠 Memory Game - AWS Static Website

A beautiful, mobile-friendly memory card matching game with modern UI design, deployed on AWS S3 with CloudFront distribution.

## 🎮 Game Features

- **Mobile-optimized**: Touch-friendly interface with haptic feedback
- **Modern UI**: Glassmorphism design with gradient colors and smooth animations
- **Fireworks effects**: Celebration animations when cards match
- **Two difficulty levels**: Easy (4x4) and Hard (4x6) grids
- **Game statistics**: Move counter, match counter, and timer
- **Responsive design**: Works on all screen sizes

## 🚀 Quick Start

### Prerequisites

- **Node.js** (>=14.0.0)
- **AWS CLI** installed and configured
- **AWS Account** with appropriate permissions

### Installation

```bash
# Clone the repository
git clone https://github.com/your-username/memory-game-aws.git
cd memory-game-aws

# Install dependencies
npm install

# Setup environment variables
npm run setup
# Edit .env file with your AWS settings
```

### Configuration

Edit the `.env` file with your settings:

```bash
# AWS Configuration
AWS_PROFILE=personal
AWS_REGION=us-east-1

# Deployment Configuration
BUCKET_NAME=your-unique-bucket-name
STACK_NAME=memory-game-hosting-stack

# Optional: Custom Domain
CUSTOM_DOMAIN=game.yourdomain.com
```

## 📦 Deployment

### Using Environment Variables (Recommended)

```bash
# Deploy to AWS
npm run deploy

# Check deployment status
npm run status

# Get deployed URLs
npm run urls
```

### Using Direct Parameters

```bash
# Deploy with parameters
npm run deploy:direct bucket-name region stack-name profile

# Example
npm run deploy:direct my-memory-game-2024 us-east-1 memory-game-stack personal
```

## 🛠️ Available Scripts

### Development
- `npm start` - Open game locally in browser
- `npm run build` - Verify static files are ready
- `npm test` - Run tests (placeholder)

### Setup & Validation
- `npm run setup` - Create .env file from template
- `npm run check-aws` - Verify AWS CLI and credentials
- `npm run validate` - Validate CloudFormation template

### Deployment
- `npm run deploy` - Deploy using .env settings
- `npm run deploy:direct` - Deploy with direct parameters

### Management
- `npm run cleanup` - Delete AWS stack using .env settings
- `npm run cleanup:direct` - Delete AWS stack with direct parameters

### Monitoring
- `npm run status` - Check CloudFormation stack status
- `npm run urls` - Display deployed website URLs
- `npm run cost` - Show AWS cost breakdown

## 📁 Project Structure

```
memory-game-aws/
├── package.json          # NPM configuration and scripts
├── index.html           # Main game file
├── error.html           # 404 error page
├── deploy.yaml          # CloudFormation template
├── .env.example         # Environment variables template
├── deploy.sh            # Main deployment script
├── cleanup-stack.sh     # Stack cleanup script
└── scripts/             # Helper scripts
    ├── check-aws.sh     # AWS setup verification
    └── load-env.sh      # Environment variable loader
```

## ☁️ AWS Resources

The deployment creates:

- **S3 Bucket**: Static website hosting with public read access
- **CloudFront Distribution**: Global CDN with HTTPS support
- **Route 53 Records**: DNS configuration (if using custom domain)
- **ACM Certificate**: SSL/TLS certificate for HTTPS

## 💰 Cost Estimation

**Monthly costs for typical usage:**

| Component | Cost |
|-----------|------|
| S3 Storage (~25KB) | $0.00 |
| S3 Requests (1K/month) | $0.0004 |
| CloudFront (1GB transfer) | $0.085 |
| Route 53 Hosted Zone | $0.50 |
| **Total** | **~$0.59/month** |

## 🌐 Access URLs

After deployment, you'll receive:

1. **S3 Website URL**: `http://bucket-name.s3-website-region.amazonaws.com`
   - Available immediately
   - HTTP only

2. **CloudFront URL**: `https://xyz123.cloudfront.net`
   - Takes 15-20 minutes to deploy
   - HTTPS with global CDN

## 🔧 Customization

### Game Modifications

1. Edit `index.html` for game logic or styling changes
2. Deploy updates:
   ```bash
   npm run deploy
   ```

### Infrastructure Changes

1. Modify `deploy.yaml` CloudFormation template
2. Validate and deploy:
   ```bash
   npm run validate
   npm run deploy
   ```

## 🐛 Troubleshooting

### Common Issues

**Bucket name already exists**
- Choose a globally unique bucket name
- Update `BUCKET_NAME` in `.env`

**Access denied errors**
- Check AWS credentials: `npm run check-aws`
- Verify IAM permissions for S3, CloudFormation, CloudFront

**CloudFront not working**
- Wait 15-20 minutes for distribution deployment
- Check status: `npm run status`

**Custom domain not resolving**
- Verify DNS records are configured
- Check domain propagation (can take up to 48 hours)

### Debug Commands

```bash
# Check AWS configuration
npm run check-aws

# Validate CloudFormation template
npm run validate

# Check deployment status
npm run status

# View deployed URLs
npm run urls

# Check costs
npm run cost
```

## 🔒 Security

- Static files only (no server-side code)
- Public read access to game files only
- CloudFront provides DDoS protection
- HTTPS enforced via CloudFront
- No sensitive data stored

## 📱 Browser Support

- Chrome/Safari/Firefox (desktop and mobile)
- iOS Safari
- Android Chrome
- Modern browsers with ES6 support

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test locally: `npm start`
5. Submit a pull request

## 📄 License

MIT License - see LICENSE file for details

## 🎯 Demo

Play the live game: [https://game.baedonguri.store](https://game.baedonguri.store)

---

**Built with ❤️ using AWS Static Website Hosting**
