import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';

export function ReportsPage() {
  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold">Content Moderation</h1>
        <p className="text-muted-foreground">
          Review and resolve user reports
        </p>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Report Queue</CardTitle>
        </CardHeader>
        <CardContent>
          <p className="text-muted-foreground">No pending reports</p>
        </CardContent>
      </Card>
    </div>
  );
}
