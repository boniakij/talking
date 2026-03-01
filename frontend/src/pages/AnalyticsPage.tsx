import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';

export function AnalyticsPage() {
  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold">Analytics</h1>
        <p className="text-muted-foreground">
          Platform insights and metrics
        </p>
      </div>

      <div className="grid gap-4 md:grid-cols-2">
        <Card>
          <CardHeader>
            <CardTitle>User Analytics</CardTitle>
          </CardHeader>
          <CardContent>
            <p className="text-muted-foreground">Charts coming soon</p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Communication Analytics</CardTitle>
          </CardHeader>
          <CardContent>
            <p className="text-muted-foreground">Charts coming soon</p>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
